# Databasium

TODO

## Usage

To start the local server

```
rails s
```

This will also start autorefresh and auto tailwind building

visit http://127.0.0.1:3000/databasium/

## Installation

### For Developing

Run this commands in the databasium repository:

```
bundle install
```

For now only records page is somewhat finished and its on its own branch add-filters-for-records, please to view it
run

```
git checkout add-filters-for-records
```

https://github.com/Unitato1/databasium/tree/add-filters-for-records

### Note:

/test/dummy is where dummy-real app used for developing is we need to migrate and seed it.

```
./test/dummy/bin/rails db:migrate
./test/dummy/bin/rails db:seed
```

visit http://127.0.0.1:3000/databasium/records

## Contributing

TODO

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
