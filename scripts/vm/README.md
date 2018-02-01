# Virtual Machine

We provide a Virtual Machine with all opeB-submission components for two purposes
- Easy development/production deployment

  Services and related tools are isolated and packed inside the VM to facilitate its distribution··

- Testing system

  Every time the virtual machine is created, after to setup all components, a series of unit tests are run to be confident with new implementation changes

## Instructions to deployment the Virtual Machine
  ```
    bundler install
    bundler exec vagrant up
  ```
_vm_config.yml_ is used to enable/disable both services and tests individually

