App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    // console.log("Connected to notifications")
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    // console.log("Disconnected to notifications")
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    document.getElementById("notification-message").innerHTML = data.html
  }
});
