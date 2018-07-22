Topics: unicode meta python
Title: Servers Need Locale
Date: 2018-06-16

I worked out why my ancient photo albums were broken.

Part 6 of the [Running to Stand Still][todo] series.


# Symptoms

When I visited [my pre-2004 albums][1] all I got was was a plain  status page
reporting status code 500 Internal Server Error.
Nothing in the logs (the access log recorded that a 500 was returned but nothing about why).

Could not reproduce it on my development server: everything worked fine.

Tried running `manage.py runserver` on my web server: it worked fine.
Tried running the sever via Gunicorn so as to be more like the deployment: still
worked fine.


# Investigation

In the end I had to put the production server itself in debug mode:

    echo y | sudo tee /service/alleged/env/DEBUG
    sudo svc -du /service/alleged

Then I got to see the error page from Django, which had a trace showed that it
was trying to read data from a CSV file and had failed to decode it as ASCII
because it contained UTF-8 data.

I checked and my locale is set by my `LANG` environment variable to
`en_GB.UTF-8`. But perhaps the  server process does not have `LANG` set, or
has it set to some non-human locale.

To check this I set the `LANG` variable for the server using the same technique as before:

    echo $LANG | sudo tee /service/alleged/env/LANG
    sudo svc -du /service/alleged

And lo! all was restored. Debugging over, so I can remove the `DEBUG` flag by removing the file:

    sudo rm /service/alleged/DEBUG


# Lessons

Set the locale of your server explicitly.





  [todo]: 06/17.html
  [1]: /albums/
