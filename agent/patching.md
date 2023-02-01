Patching Configurations
------------------------

Select VM instances manually
	Individually select VM instances. You can select a maximum of 500 VM instances.


Select VM instances groups
	Select Certain Groups

	Filter VMs that name start with ...
	Filter VMs that name start end ...
	Filter VMs based on labels


Select types of upgrade to perform

- apt-get dist-upgrade
- apt-get upgrade

Packages to Upgrade

Packages to Exclude


Post-patch reboot option:
-------------------------

- Default: The agent will decide if a reboot is necessary by checking well known signals on each OS.
- Always: The machine will reboot after the update.
- Never: The machine will not reboot after the update.


Pre-patch scripts:
	Pre-patch scripts run before patching starts, or, if a reboot is required, before the reboot.

Post-patch scripts:
	Post-patch scripts run after patching completes, or, if a reboot is required, after the reboot.


Rollout Options:
----------------
Threshold Type (Percent of VMs or Number of VMs)
Threshold Value (4 or 25%)



Schedule Type:
--------------

Time in the Future or Recurring
