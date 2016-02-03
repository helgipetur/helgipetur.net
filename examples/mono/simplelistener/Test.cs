using NUnit.Framework;

using System;
using Nancy;
using Nancy.Testing;
using simplelistener;

namespace simplelistener_tests
{
	[TestFixture ()]
	public class Test
	{
		[Test ()]
		public void ShouldReturnOkOnRoot ()
		{
			// Given
			var browser = new Browser (with => with.Module<SimpleListener> ());

			// When
			var res = browser.Get ("/", with => {
				with.HttpRequest ();
			});

			// Then
			Assert.AreEqual (HttpStatusCode.OK, res.StatusCode);
		}
	}
}

