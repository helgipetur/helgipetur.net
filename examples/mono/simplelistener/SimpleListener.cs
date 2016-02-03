using System;
using Nancy;
using Nancy.Hosting.Self;
using log4net;

namespace simplelistener
{
	public enum Health
	{
		Healthy,
		Sick
	}

	public class SimpleListener : NancyModule
	{
		private int _requestCounter;

		public SimpleListener ()
		{
			_requestCounter = 0;
			Get ["/"] = parameters => "Hello World!";
			Get ["/healthcheck/"] = _ => {
				return this.GetHealthCheck ();
			};
		}

		private object GetHealthCheck ()
		{
			return new {
				status = Health.Healthy,
				date = DateTime.Now,
				requests = _requestCounter++
			};
		}
	}
}
