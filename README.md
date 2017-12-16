# DigitalSignage

This a project of the DLSS Digital Signage Studio.

## Data sources

- IIIF manifests
- Stanford Exhibits

## Usage

Set the `TELEMETRY_BATCH_API_URL` environment variable to the full telemetryTV API endpoint (basic auth token and all), and then run the `report` task to collect and send all data to the digital signage APIs:

```bash
$ TELEMETRY_BATCH_API_URL=... rake report
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sul-dss/digital_signage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the DigitalSignage project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sul-dlss/digital_signage/blob/master/CODE_OF_CONDUCT.md).
