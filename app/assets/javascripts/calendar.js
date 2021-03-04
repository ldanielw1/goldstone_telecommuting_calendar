/**
 * Customizes the FullCalendar view in the dashboard view.
 */
function loadCalendar() {
  next_month = gon.data["next_month"]
  next_year = gon.data["next_year"]
  this_month = gon.data["this_month"]
  this_year = gon.data["this_year"]
  prev_month = gon.data["prev_month"]
  prev_year = gon.data["prev_year"]

  $('#meetings_calendar').fullCalendar({
    title: "MM YYYY",
    eventSources: [ gon.data["events"] ],
    defaultDate: gon.data["default_date"],

	defaultView: 'agendaWeek',
    hiddenDays: [0,6],
    minTime: '08:00:00',
    maxTime: '19:00:00',
    height: 985,
    aspectRatio: 1.2,
    expandRows: true,
    nowIndicator: true,
    header: {
      left: 'title',
      center: '',
      right: 'prev, today, next'
    },

    // Update UI after everything loads
    eventAfterAllRender: function(view) {
      // Remove Google Links
      $("a.fc-event").each(function(index, child) {
        if (typeof($(child).attr('href')) != 'undefined')
          $(child).removeAttr('href');
      });

      // Add keyboard shortcuts for prev/today/next behavior
      window.onkeyup = function(e) {
        var key = e.keyCode ? e.keyCode : e.which;
        if (key == 80) // prev
          $(".fc-prev-button").click();
        else if (key == 84) // today
          $(".fc-today-button").click();
        else if (key == 78) // next
          $(".fc-next-button").click();
      }
    },
  });
}

function loadCalendarForDashboard() {
  url = getRoute();
  if (url == "")
    loadCalendar();
}

$(document).on('turbolinks:load', loadCalendarForDashboard);
