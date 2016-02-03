using System;
using Nancy.Hosting.Self;
using log4net;
using System.Threading;
using log4net.Config;
using Mono.Unix;
using Mono.Unix.Native;
using Nancy;

namespace simplelistener
{
	public class Service
	{
		static ILog log;

		public static void Main (string[] args)
		{
			BasicConfigurator.Configure ();
			log = LogManager.GetLogger (typeof(SimpleListener));
			StaticConfiguration.DisableErrorTraces = false;
			var uri = "http://localhost:8888";
			log.Debug ("Starting up on " + uri);
			var host = new NancyHost (new Uri (uri));
			log.Debug ("Starting Nancy");
			host.Start ();
			if (Type.GetType ("Mono.Runtime") != null) {
				UnixSignal.WaitAny (new [] {
					new UnixSignal (Signum.SIGINT),
					new UnixSignal (Signum.SIGTERM),
					new UnixSignal (Signum.SIGQUIT),
					new UnixSignal (Signum.SIGHUP)
				});
			} else {
				Console.ReadLine ();
			}
			log.Debug ("Stopping Nancy");
			host.Stop ();
			log.Debug ("Exiting");
		}
	}
}

