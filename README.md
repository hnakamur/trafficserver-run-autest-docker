# trafficserver-run-autest-docker

In each directory of ubuntu2204 and ubuntu2004, run the following command to build and run autest:

```
make build
```

And then run the following command to get the log files:

```
make getlogs
```

Finally you can view the log files like the following:

```
less -R autest.log
```
