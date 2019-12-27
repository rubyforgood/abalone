App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    // console.log("Connected to notifications")
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    // console.log("Disconnected to notifications")
  },

  received: function({ content: { invalid_headers, valid_headers, notification_type, notification_title }}) {
    const $notificationErrorType = $('.notification-error-type');
    const $notificationErrorContent = $('.notification-error-content');
    const $notificationErrorTitle = $('.notification-error-title');

    const wrap = tagName => contents => `<${tagName}>${Array.from(contents).join('')}</${tagName}>`
    const ul = wrap('ul');
    const li = wrap('li');

    const list = items => ul(items.map(li));

    $notificationErrorTitle.html(notification_title);
    $notificationErrorContent.html(list(invalid_headers));
    $notificationErrorType.addClass(`is-${notification_type}`);
  }
});