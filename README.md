# iCalendar

A very minimal parser for the iCalendar [RFC 5545](https://tools.ietf.org/html/rfc5545) format written in Swift.

It currently only supports [VEVENT](https://tools.ietf.org/html/rfc5545#section-3.6.1) objects and only parses the following VEVENT keys:
- DTSTART
- DTEND
- UID
- DESCRIPTION
- LOCATION
- SUMMARY

This limited functionality is enough to support the purpose for which it was created, which is for parsing and writing out iCalendar (.ics) files as used by the major holiday rental and accomodation booking channels such as [AirBnB](airbnb.com), [Booking.com](booking.com) and [Wimdu](wimdu.com).
