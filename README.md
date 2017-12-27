# NOTE: This example was created on an outdated version of the Lob API. Please see the latest [Lob documentation](https://lob.com/docs) for the most up to date implementation.

# README

### Using Lob Webhooks to Send Delivery Notifications in Rails

Traditionally, tracing mail is a difficult and time consuming process. However recently tech innovations are quickly changing the landscape. Most of our customers, once their collateral has entered the mail stream, would like to keep track of their pieces as they move through transit.

With Lob, you can set up webhooks to receive up to date tracking events in real time, to help you track exactly where your mail is in the delivery process. This tutorial will show you how to build a Rails web app implementing Lob's webhook functionality.

### What are we building?

This tutorial will show you how to build a website to verify your personal address by sending a postcard with an address verification code. Once you build the site and add an intake form, you can use Lob's webhooks to set up automated emails as the postcard moves through transit and delivery.
