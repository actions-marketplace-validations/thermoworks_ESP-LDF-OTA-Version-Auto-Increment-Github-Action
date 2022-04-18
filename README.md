# ESP-LDF OTA Version Increment

This Action will increment the version file of an ESP-LDF Project by one.

## Example usage

```
name: App Version Actions
on: [push, pull_request]  # Recommended to use either of one event

jobs:
  Version-check:
    runs-on: ubuntu-latest
    name:  ESP-LDF OTA Version Increment
    steps:
    - uses: actions/checkout@master
    - name: Increment version
      id: version
      uses: thermoworks/ESP-LDF-OTA-Version-Auto-Increment-Github-Action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
