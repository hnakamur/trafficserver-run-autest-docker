# trafficserver-run-autest-docker

In each directory of ubuntu{18,20,22}04, run the following command to build trafficserver and run `make check` in a Docker container:

```
make build
```

Run the following command to run autest in the Docker container built with the above command:

```
make test
```

Finally you can view the log files like the following:

```
less -R log/build.log
less -R log/autest.log
```
