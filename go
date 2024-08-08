---
syntax: bash
tags: [ golang, go ]
---

# description
Notes on golang

# install

# config

# doc

# setup
brew install go
mkdir $HOME/go
GOPATH=$HOME/go (optional?)
create foo.go
go build foo.go
## if tons of llvm_ errs then CC=gcc and rerun 'build'

# print version
go version

# install pkg
#Executables installed in $GOBIN, defaults to $GOPATH/bin or $HOME/go/bin if GOPATH is not set.
#Executables in $GOROOT installed in $GOROOT/bin or $GOTOOLDIR instead of $GOBIN.
go install [build flags] [packages] # Install compiles and installs the packages named by the import paths.

# fast dir scanner
https://github.com/spikebike/go-dirscan

# docker
(https://blog.docker.com/2016/09/docker-golang/?mkt_tok=eyJpIjoiWkdRd05qbGpZbVE1T1dFNCIsInQiOiJNSVdvOU1hOHVBbVhBVkpTYmk0UTNtaE1IXC9xMjNaZTRMc2Rsd1wvbkJsZmFmS0lcLzBtVzJYZ1hDTlJ3cjFKVXB5SHpKd0dqRmhFZXUwWWlvQ1wvVCtyMXFtRnFFUFY2U3hOYW92OEplRWlHYXc9In0%3D)
docker run golang go get -v github.com/golang/example/hello/...
docker commit $(docker ps -lq) awesomeness
docker run awesomeness hello

# go docker but cleanup container at end
docker run --rm golang sh -c  "go get github.com/golang/example/hello/... && exec hello"

# go docker difft version of go
docker run --rm golang:1.5 sh -c "go get github.com/golang/example/hello/... && exec hello"

# copy image out of docker
docker run -v /tmp/bin:/go/bin golang go get github.com/golang/example/hello/...
/tmp/bin/hello  # now run local copy

#  cross-compile with docker
docker run -e GOOS=darwin -e GOARCH=amd64 -v /tmp/crosstest:/go/bin golang go get github.com/golang/example/hello/...
#
/tmp/crosstest/darwin_amd64/hello

# arch / os
go env GOOS
go env GOARCH

# x86_64
GOARCH=amd64 # there is no x86_64 keyword for go but it means the same thing

# arch
go tool dist list

# projects
https://github.com/avelino/awesome-go

# go get -- deprecated ; see go install
installs to $GOPATH
echo $GOPATH
go get -u -v github.com/nicholasjackson/go-microservice-template
l  /usr/local/Cellar/go/1.6/src/github.com/nicholasjackson/go-microservice-template/

# install - Executables installed in GOBIN [ $GOPATH/bin ] or $HOME/go/bin if GOPATH is not set.
# Executables in $GOROOT are installed in $GOROOT/bin or $GOTOOLDIR instead of $GOBIN.
go install lucaspepe/pwsafe@latest ## <-- need @VERSION
go install github.com/cloudflare/gokey/cmd/gokey@latest
go install github.com/chanzuckerberg/s3parcp@latest

# go / biogo
go get github.com/biogo/ncbi/blast
go get github.com/biogo/ncbi/entrez
  # /usr/local/Cellar/go/1.7/src/github.com/biogo/ncbi/entrez/

# go microservices
http://nicholasjackson.github.io/microservices/go/building-and-testing-microservices-part1/?mkt_tok=3RkMMJWWfF9wsRonuqTMZKXonjHpfsX57uorWaKwlMI%2F0ER3fOvrPUfGjI4DS8FjI%2BSLDwEYGJlv6SgFQ7LMMaZq1rgMXBk%3D

# run
go run

# module - programs and libs built around core concept of module: info about libs (and versions) used by your program .
In order to tell Go that <foo> is a Go module
go mod init <foo>

# modules -- modules are the future of dependency management in Go. Module functionality is available Go versions >= 1.11
# see https://go.dev/blog/using-go-modules
go mod init # creates a new module, initializing the go.mod file that describes it.
go build, go test, # and other package-building commands add new dependencies to go.mod as needed.
go list -m all # prints the current module’s dependencies.
go get # changes the required version of a dependency (or adds a new dependency).
go mod tidy # removes unused dependencies.

# To run the package in the current directory
go run .

# To run the package in the ./cmd/foo directory
go run ./cmd/foo/

# To fetch dependencies
go get github.com/foo/bar@v1.2.3
go get github.com/foo/bar@8e1b8d3

# Upgrade the dependency.
go get -u github.com/foo/bar

# Building an Executable.
go build -o=/tmp/foo . # Compile the package in the current directory
go build -o=/tmp/foo ./cmd/foo # Compile the package in the ./cmd/foo directory

# Build cache
go env GOCACHE # Check where your build cache is
go build -a -o=/tmp/foo . # Force all packages to be rebuilt
go clean -cache # Remove everything from the build cache

# Cross-Compilation
GOOS=linux GOARCH=amd64 go build -o=/tmp/linux_amd64/foo .
GOOS=windows GOARCH=amd64 go build -o=/tmp/windows_amd64/foo.exe .

# List of all supported OS/architectures
go tool dist list

# To show all the dependencies of the module
go list -m all

# To sho why is that a dependency?
go mod why -m golang.org/x/sys

# Clear module cache -- can be huge
go clean -modcache

# View simplified documentation for the strings package
go doc strings

# View full documentation for the strings package
go doc -all strings

# View documentation for the strings.Replace function
go doc strings.Replace

# View documentation for the database/sql.DB type
go doc sql.DB

# View documentation for the database/sql.DB.Query method
go doc sql.DB.Query

# View the source code for the strings.Replace function
go doc -src strings.Replace

# Run all tests in the current directory
go test .

# Run all tests in the current directory and sub-directories
go test ./...

# Run all tests in the ./foo/bar directory
go test ./foo/bar

# Testing with race detector
go test -race ./...

# Bypass the test cache when running tests
go test -count=1 ./...

# Delete all cached test results
go clean -testcache

# Run the test with the exact name TestFooBar
go test -v -run=^TestFooBar$ .

# Run tests whose names start with TestFoo
go test -v -run=^TestFoo .

# Run the Baz subtest of the TestFooBar test only
go test -v -run=^TestFooBar$/^Baz$ .

# Handy flag - skip long running tests
go test -short ./...

# Handy flag - don't run further tests after a failure.
go test -failfast ./...

# Test all module dependencies.
go test all

# Stress testing
go test -run=^TestFooBar$ -count=500 .

# Upgrading the code to a New Go Release
go fix ./...

# Create a new Github issue for Go's standard library
go bug

# Running and Comparing Benchmarks
go test -bench=. ./... # Run all benchmarks and tests
go test -run=^$ -bench=. ./... # Run all benchmarks (and no tests)
go test -run=^$ -bench=^BenchmarkFoo$ ./... # Run only the BenchmarkFoo benchmark (and no tests)
go test -bench=. -benchmem ./... # Forces the output of memory allocation statistics
go test -bench=. -benchtime=5s ./... # Run each benchmark test for at least 5 seconds
go test -bench=. -benchtime=500x ./... # Run each benchmark test for exactly 500 iterations
go test -bench=. -count=3 ./... # Repeat each benchmark test 3 times over
go test -bench=. -cpu=1,4,8 ./... # Run benchmarks with GOMAXPROCS set to 1, 4 and 8

# Comparing changes between benchmarks
go get golang.org/x/tools/cmd/benchcmp@latest # Install the compare tool.
go test -run=^$ -bench=. -benchmem ./... > /tmp/old.txt # Measure benchmark before changes
go test -run=^$ -bench=. -benchmem ./... > /tmp/new.txt # Measure benchmark after changes
benchcmp /tmp/old.txt /tmp/new.txt  # Compare changes.

# Using Compiler and Linker Flags
go tool compile -help # complete list of available compiler flags
go build -gcflags="-m -m" -o=/tmp/foo . # print optimization decisions
go build -gcflags="all=-m" -o=/tmp/foo . # optimization decisions for dependencies too
go build -gcflags="all=-N -l" -o=/tmp/foo . # disable optimizations and inlining
go tool link -help # list of available linker flags
go build -ldflags="-X main.version=1.2.3" -o=/tmp/foo . # add a version number
go build -ldflags="-s -w" -o=/tmp/foo . # strip debug information from the binary
CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' . # make the binary as static as possible

# Trace generation
go test -run=^$ -bench=^BenchmarkFoo$ -trace=/tmp/trace.out .
go tool trace /tmp/trace.out # Works only on Chrome / Chromium at the moment

# Viewing Environment Information
go env # List all environment variables.
go env -w GOPATH=/foo/bar # Set GOPATH environment variable to /foo/bar

# Checking for Race Conditions
go build -race -o=/tmp/foo . # not for production

# ~/.cache/go -- holds cached build artifacts from the Go build system.
Run "go clean -cache" if the directory is getting too large.
Run "go clean -fuzzcache" to delete the fuzz cache.

# pprof
pprofFile, pprofErr := os.Create("cpu.pprof")
if pprofErr != nil {
  log.Fatal(pprofErr)
}
pprof.StartCPUProfile(pprofFile)
defer pprof.StopCPUProfile()
-- then
go tool pprof -http=":8080" ./goprog ./cpu.pprof

# debug build
go build -x

# revive
fast go linter

# Error: revive: No such file or directory
# Given:
  make vet
  all modules verified
  revive -exclude vendor/... ./...
  make: revive: No such file or directory
  make: *** [lint] Error 1
#Fix: make setup
  GO111MODULE=off go get -u github.com/boyter/scc github.com/mgechev/revive
