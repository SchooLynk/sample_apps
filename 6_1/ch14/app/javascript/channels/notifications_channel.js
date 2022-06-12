import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    $('#notifications').html('');
    $.each(data.content, function (index, notification) {
      $('#notifications').append(
        '<li><div class="notification">'
        + '<div class="notification-text">' + notification.text + '</div>'
        + '<div class="notification-time">' + notification.time + '</div>'
        + '</div></li>'
      );
    });
  }
});
