require 'google_calendar'

class CalendarController < ApplicationController
  before_action :get_date_data

  def view
    # Get data from events
    event_list = get_events()
    @events = []
    event_list.each do |event|
      data = event.raw
      start_time = remove_datetime_timezone(data["start"])
      end_time = remove_datetime_timezone(data["end"])
      title = data["summary"]

      color = get_color(title)
      @events << { start: start_time, end: end_time, title: title.strip, color: color }
    end
    gon.data = {
      events: @events,
      default_date: get_date_string(@default_date),
      prev_date: get_date_string(@prev_date),
      next_date: get_date_string(@next_date),
      today: get_date_string(@today)
    }
  end

  private

  def get_events()
    client_id = "1086373931912-sgb7vl36nog4ph3jgjmqsl54h1jghro7.apps.googleusercontent.com"
    client_secret = "Qxa9DjjxiZfo-OxCOBCxbkCS"
    calendar_id = "c_t8bc1nlh6tkk3ffole2f4q3q5g@group.calendar.google.com"
    redirect_url = "urn:ietf:wg:oauth:2.0:oob" # this is what Google uses for 'applications'
    refresh_token = "1/y1W7Ork9IUo038jCPpueS0ll-dluHuxhypY-etGG2Uc"

    # Get calendar
    cal = Google::Calendar.new(:client_id => client_id, :client_secret => client_secret, :calendar => calendar_id, :redirect_url  => redirect_url)
    cal.login_with_refresh_token(refresh_token)

    # Download events
    events_hash = Hash.new
    day = @default_date
    end_date = @default_date + 5
    while day <= end_date # Assumes that there aren't more than 25 events per day
      new_events = cal.find_events_in_range(day.to_time, end_date.to_time)
      new_events.each { |event| events_hash[event.id] = event }
      break if new_events.length < 25
      last_event = new_events[-1]
      day = get_datetime(last_event.raw["start"])
    end
    events = []
    events_hash.each do |id, event|
      next if event.status != "confirmed"
      events << event
    end
    events = events.sort_by { |event| get_datetime(event.raw["start"]) }

    return events
  end

  def get_datetime(time)
    return Date.parse(time["dateTime"]).to_date if time.has_key?("dateTime")
    return Date.new(time["date"]).to_date
  end

  def remove_datetime_timezone(time)
    return time["dateTime"].split("-")[0..2].join("-")
  end

  def get_date_data
    @today = Date.today
    if params["default_date"]
      input_date = Date.parse(params["default_date"])
      @default_date = input_date - (input_date.wday - 1)
    else
      start_of_week = @today - (@today.wday - 1)
      @default_date = start_of_week
    end
    @prev_date = @default_date - 7
    @next_date = @default_date + 7
  end

  def get_date_string(date)
    return "#{date.year.to_s.rjust(2, "0")}-#{date.month.to_s.rjust(2, "0")}-#{date.day.to_s.rjust(2, "0")}"
  end

  def get_color(title)
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
    elsif title =~ /^G: /
      color = is_me ? "#1c8600" : "#baffa8"
    else
      color = is_me ? "#c30000" : "#ffb5b5"
    end
    return color
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
