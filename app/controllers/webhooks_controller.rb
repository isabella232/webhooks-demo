class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    raw = request.body.read
    data = JSON.parse(raw)

    last_tracking_event = data['body']['tracking_events'][-1]
    postcard_id = data['body']['id']

    TrackingWorker.perform_async(postcard_id, last_tracking_event['name'], last_tracking_event['location'], last_tracking_event['time'])

    render status: 200, json: {}.to_json
  end
end
