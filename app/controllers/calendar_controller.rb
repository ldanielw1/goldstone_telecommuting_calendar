require 'google_calendar'

class CalendarController < ApplicationController
  before_action :get_date_data

  def view
    # Get data from events
    event_list, month, year = get_events(@month, @year)
    @events = []
    event_list.each do |event|
      data = event.raw
      start_time = remove_datetime_timezone(data["start"])
      end_time = remove_datetime_timezone(data["end"])

      # Get event color
      title = data["summary"]
      is_me = title =~ /#{get_nicknames()}/i
      color = nil
      if title =~ /^1: /
        color = is_me ? "#0069d6" : "#cfe6fd"
      elsif title =~ /^2: /
        color = is_me ? "#e65e00" : "#ffdec8"
      elsif (title =~ /^LR: /) || (title =~ /^BR: /)
        color = is_me ? "#464646" : "#e8e8e8"
      elsif title =~ /^QUIET: /
        color = is_me ? "#8200bb" : "#f0ceff"
      else
        color = is_me ? "#c30000" : "#ffb5b5"
      end

      title = filter_title(title)
      @events << { start: start_time, end: end_time, title: title.strip, color: color }
    end
    gon.data = {
      events: @events,
      default_date: "#{year}-#{month}-8",
      prev_month: @prev_month,
      prev_year: @prev_year,
      this_month: @this_month,
      this_year: @this_year,
      next_month: @next_month,
      next_year: @next_year
    }
  end

  private

  def get_events(month, year)
    client_id = "1086373931912-sgb7vl36nog4ph3jgjmqsl54h1jghro7.apps.googleusercontent.com"
    client_secret = "Qxa9DjjxiZfo-OxCOBCxbkCS"
    calendar_id = "c_t8bc1nlh6tkk3ffole2f4q3q5g@group.calendar.google.com"
    redirect_url = "urn:ietf:wg:oauth:2.0:oob" # this is what Google uses for 'applications'
    refresh_token = "1/y1W7Ork9IUo038jCPpueS0ll-dluHuxhypY-etGG2Uc"

    # Get calendar
    cal = Google::Calendar.new(:client_id => client_id, :client_secret => client_secret, :calendar => calendar_id, :redirect_url  => redirect_url)
    cal.login_with_refresh_token(refresh_token)

    # Get next month
    next_month_year = month == 12 ? year + 1 : year
    next_month_month = month == 12 ? 1 : month + 1
    next_month = Time.new(next_month_year, next_month_month, 1)
    month_end_day = next_month.to_date.prev_day.day

    # Download events
    events_hash = Hash.new
    day = 1
    while day <= month_end_day
      date_range_start = Time.new(year, month, day)
      new_events = cal.find_events_in_range(date_range_start, next_month)
      new_events.each { |event| events_hash[event.id] = event }
      break if new_events.length < 25
      last_event = new_events[-1]
      day = get_datetime(last_event.raw["start"]).day
    end
    events = []
    events_hash.each do |id, event|
      next if event.status != "confirmed"
      events << event
    end
    events = events.sort_by { |event| get_datetime(event.raw["start"]) }

    return events, month, year
  end

  def get_datetime(time)
    return Time.parse(time["dateTime"]) if time.has_key?("dateTime")

    date = Time.new(time["date"]).to_s
    return "#{date[0]}T#{date[1]}#{date[2]}"
  end

  def remove_datetime_timezone(time)
    return time["dateTime"].split("-")[0..2].join("-") if time.has_key?("dateTime")

    date = Time.new(time["date"]).to_s
    return "#{date[0]}T#{date[1]}"
  end

  def filter_title(title)
    # Shorten titles for event names
    title = title.gsub(/Sunday Worship Service/, "SWS")
    title = title.gsub(/Devotions\+Prayer/, "Devotions")
    return title
  end

  def get_date_data
    # Set variables for current month/year
    @this_month = Time.now.month
    @this_year = Time.now.year

    # Get current month/year from current date or from input params
    @month = params["month"]
    @year = params["year"]
    if @month == nil or @year == nil
      month_start = Time.new(@this_year, @this_month, 1)
      @month = month_start.month
      @year = month_start.year
    else
      @month = @month.to_i
      @year = @year.to_i
    end

    # Get next/previous years + months
    @next_year = @year
    @prev_year = @year
    if @month == 12
      @next_year = @year + 1
    elsif @month == 1
      @prev_year = @year - 1
    end
    @next_month = (@month == 12) ? 1 : (@month + 1)
    @prev_month = (@month == 1) ? 12 : (@month - 1)
  end

  def get_nicknames()
    name = @current_user.name
    if name =~ /taipei/i
      return "taipei"
    elsif name =~ /richard edwards/i
      return "richard"
    elsif name =~ /kevin woo/i
      return "kwoo"
    elsif name =~ /greg wing/i
      return "greg"
    elsif name =~ /jermaine zhang/i
      return "jermaine"
    elsif name =~ /kevin wong/i
      return "kwong"
    elsif name =~ /david lee/i
      return "dlee"
    elsif name =~ /david choi/i
      return "dchoi"
    elsif name =~ /andrew hoang/i
      return "andrew"
    elsif name =~ /ryan walsh/i
      return "ryan"
    elsif name =~ /daniel kim/i
      return "dk"
    elsif name =~ /luis luna/i
      return "luis"
    elsif name =~ /josiah remo/i
      return "JD"
    end
    raise RuntimeError, "No nicknames given for current user"
  end

end
