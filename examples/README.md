Service examples
===

This folder contains examples of the different service types in different languages

* simple services will serve on port 10000
* all services expose the ~/healthcheck/ endpoint that will serve struct like this:
´´´´
{
	"time": "2015-12-12T12:12:12.999+00",
	"endpoint": "serviceendpoint",
	"healthy": 0,
	"reason": "No reason, 0 means healthy"
}
````
* services use log4xxx to log to stdout/stderr, no local log files
* dates are represented as iso 8601 strings: YYYY-MM-DDTHH:MM:SS.mmmmmm+HH:MM
