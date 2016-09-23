
Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.define("sendPushToChannels", function(request, response) {

var channels = request.params.channels;
var message = request.params.message;

// Send the push notification to the selected channels
Parse.Push.send({
  channels: channels,
  data: {
    alert: message
  }
}, { useMasterKey: true }
).then(function() {
    response.success("Push was sent successfully.")
}, function(error) {
    response.error("Push failed to send with error: " + error.message);
});

});

