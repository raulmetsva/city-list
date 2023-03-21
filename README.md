# Some notes about this cities-list app by the developer

## users

admin/admin - will be able to edit the name and image of the cities

user/password - will only be able to browse/search the list (but not edit)

## to run

first run this to build -

```sh
docker build --build-arg API_ENDPOINT_ARG={backend address} -t kn-hw-fe .
```

(backend project is at https://github.com/sven-kanoshin/kn-hw-be and needs to be run separately with the instructions included)

then run this to run -

```sh
docker run -d --name=kn-hw-fe -p 7070:8080 kn-hw-fe:latest
```

## other notes

The session lasts for 60 minutes (as configured in the BE) so if some browsing/searching/editing is tried after that the user will be "logged out" in FE as well and directed to login page

Search bar works so that a new request is not done before 1 second has passed since the last keystroke (to avoid a lot of unnecessary requests)
