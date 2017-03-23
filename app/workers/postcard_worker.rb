class PostcardWorker
  include Sidekiq::Worker

  def perform(user_id)
    lob = Lob::Client.new(api_key: ENV['LOB_API_KEY'])
    user = User.find(user_id)

    postcard = lob.postcards.create({
      description: "Verification Postcard - #{user.id}",
      to: {
        name: user.first_name + " " + user.last_name,
        address_line1: user.address_line1,
        address_line2: user.address_line2,
        address_city: user.address_city,
        address_state: user.address_state,
        address_country: user.address_country,
        address_zip: user.address_zip
      },
      from: {
        name: "Larry Lobster",
        address_line1: "185 Berry St, Suite 6600",
        address_city: "San Francisco",
        address_state: "CA",
        address_country: "US",
        address_zip: "94110"
      },
      front: %Q(
      <html>
        <head>
        <meta charset="UTF-8">
        <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:700' rel='stylesheet' type='text/css'>
        <title>Lob.com Address Verification 4x6 Postcard Template Front</title>
        <style>
        *, *:before, *:after {
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
        }
        body {
          width: 6.25in;
          height: 4.25in;
          margin: 0;
          padding: 0;
          /* your background image should have dimensions of 1875x1275 pixels. */
          background-image: url('https://s3-us-west-2.amazonaws.com/lob-assets/homelove-pc-bg.jpg');
          background-size: 6.25in 4.25in;
          background-repeat: no-repeat;
        }
        /* do not put text outside of the safe area */
        #safe-area {
          position: absolute;
          width: 5.875in;
          height: 3.875in;
          left: 0.1875in;
          top: 0.1875in;
          text-align: center;
        }
        #logo {
          height: 1in;
          position: relative;
          top: .9in;
        }
        #tagline {
          position: relative;
          top: 1in;
          font-family: 'Source Sans Pro';
          font-weight: 700;
          font-size: .16in;
          text-transform: uppercase;
          letter-spacing: .03in;
          color: white;
          border-top: 1px solid white;
          padding-top: .15in;
          width: 4in;
          margin: auto;
        }
        </style>
        </head>

        <body>
        <!-- do not put text outside of the safe area -->
        <div id="safe-area">

          <!-- your logo here! -->
          <img src="https://s3-us-west-2.amazonaws.com/lob-assets/homelove-logo.png" id="logo">

          <div id="tagline">
            Get verified and start selling!
          </div>

        </div>
        </body>

        </html>
      ),
      back: %Q(
        <html>
        <head>
        <meta charset="UTF-8">
        <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700' rel='stylesheet' type='text/css'>
        <title>Lob.com Address Verification 4x6 Postcard Template Back</title>
        <style>

          *, *:before, *:after {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
          }

          body {
            width: 6.25in;
            height: 4.25in;
            margin: 0;
            padding: 0;
            background-color: white;
          }

          #banner {
            height: 1in;
            background-color: #9b2a62;
            font-family: 'Source Sans Pro';
            font-weight: 700;
            font-size: .16in;
            text-transform: uppercase;
            letter-spacing: .03in;
            color: white;
            text-align: center;
            padding-top: .5in;
          }

          /* do not put text outside of the safe area */
          #safe-area {
            position: absolute;
            width: 5.875in;
            height: 3.875in;
            left: 0.1875in;
            top: 0.1875in;
          }

          #message {
            position: absolute;
            width: 2.2in;
            height: 2in;
            top: 1.1in;
            left: .25in;
            font-family: 'Source Sans Pro';
            font-weight: 400;
            font-size: .13in;
          }

          #code-banner {
            text-align: center;
            font-size: .13in;
          }

          #code {
            font-family: 'Source Sans Pro';
            font-weight: 700;
            font-size: .13in;
            text-transform: uppercase;
            letter-spacing: .02in;
            color: #9b2a62;
            border: 2px solid #9b2a62;
            width: 2in;
            padding: .1in;
            margin: .1in auto;
          }

          .accent {
            color: #9b2a62;
          }

        </style>
        </head>

        <body>
          <div id="banner">
            {{first_name}} - Verify Your Address
          </div>

          <!-- do not put text outside of the safe area -->
          <div id="safe-area">
            <div id="message">
              <span class="accent">{{first_name}},</span>
              <br><br>
              This postcard serves as verification of your address.
              <br><br>
              <div id="code-banner">
                Visit <span class="accent">https://www.acme.com/verify</span> and enter:
                <div id="code">
                  {{verification_code}}
                </div>
              </div>
              <br>
            </div>
          </div>
        </body>

        </html>
      ),
      data: {
        first_name: user.first_name,
        verification_code: user.verification_code
      },
      metadata: {
        user_id: user.id
      }
    )

    user.update(verification_postcard_id: postcard['id'])
  end
end
