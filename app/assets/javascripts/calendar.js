/**
 * Customizes the FullCalendar view in the dashboard view.
 */
function loadCalendar() {
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

      // Adjust prev/today/next behavior
      url = window.location.href
      $(".fc-prev-button").unbind();
      $(".fc-prev-button").click(function(event) {
        window.location.href = url.split("?")[0] + "?default_date=" + gon.data["prev_date"];
      });
      $(".fc-next-button").unbind();
      $(".fc-next-button").click(function(event) {
        window.location.href = url.split("?")[0] + "?default_date=" + gon.data["next_date"];
      });
      $(".fc-today-button").unbind();
      $(".fc-today-button").click(function(event) {
        window.location.href = url.split("?")[0] + "?default_date=" + gon.data["today"];
        event.stopPropagation();
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
