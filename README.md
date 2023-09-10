# sf-food-truck-finder

Webservice app for finding particular food trucks in San Francisco

The SF Food Truck Finder is a small webservice utility application that lets you locate particular food trucks in the San Francisco area.  You can search by name, and type of food.  You can also limit the number of results supplied.  It uses publically available data which can be found at https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data.

## Getting Sstarted

To quickly get the application up and running, simply clone the repo to a computer that has docker compose installed.

$ git clone https://github.com/jtwauthier/sf-food-truck-finder

$ cd sf-food-truck-finder

$ docker-compose up -d

Sometimes, the database doesn't get fully populated.  There are a couple of reasons why this may happen.  however, the fix for this is simple.  There is a data loader script included.  Just run the script, and everything should load properly.

You can check to ensure the data has been loaded properly as so.

$ docker exec finder-app sqlite3 data/FTData.db "select count(*) from vendors"

If the result to the above command is "0", you can do this.

$ docker exec finder-app ./script/getFTData.pl

Then, you can verify that the data has been loaded again.

$ docker exec finder-app sqlite3 data/FTData.db "select count(*) from vendors"

You can run the included test script.

$ docker exec finder-app prove -lv t/FTF/App.t

After the application is up, you can access it by using your browser to make a request to the IP address of your system on port 3000.

$ curl http://localhost:3000/

If you would like to filter down the results, you can supply keywords to be matched against the name of the vendors and/or the foods they provide.

$ curl http://localhost:3000/?keywords=taco,burger

To limit the number of results you get back, simply add a size parameter to the query string.

$ curl http://localhost:3000/?keywords=taco,burger&size=5

If you would like to see what the application is doing internally, you can check out the log.

$ docker exec finder-app cat log/ftf.log

## Notes

I decided to put the app in a docker container because environment and maintainability are important.  I believe that containerizing the application makes it easier for users to control the environment in which the app runs.  It also makes deployment much easier.

I decided to use Mojolicious as the web framework because it is stable and dependable.  While such a lightweight application could have been implemented more quickly in Dancer or another framework, I felt that Mojolicious would be a better long-term option for stability and maintainability.  it also makes extending the functionality of the system easier down the road.

I decided to store the vendor data in a local database because it makes searching the data easier and quicker.  It also makes sure that the data is available in the event that the remote server is unavailable, and it reduces demand on the remote server.

I added logging to the project because it makes auditing and troubleshooting easier.  This is always valuable in production code.

