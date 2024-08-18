{
  disko.devices = {
    disk.sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt"; # Initialize the disk with a GPT partition table
        partitions = {
          ESP = { # Setup the EFI System Partition
            type = "EF00"; # Set the partition type
            size = "256M";
            content = {
              type = "filesystem";
              format = "vfat"; # Format it as a FAT32 filesystem
	      mountpoint = "/boot"; # Mount it to /boot
	      mountOptions = [
		"defaults"
	      ];
            };
          };
          primary = { # Setup the LVM partition
            size = "100%"; # Fill up the rest of the drive with it
            content = {
              type = "lvm_pv"; # pvcreate
              vg = "vg1";
            };
          };
        };
      };
    };
    lvm_vg = { # vgcreate
      vg1 = { # /dev/vg1
        type = "lvm_vg";
        lvs = { # lvcreate
          swap = { # Logical Volume = "swap", /dev/vg1/swap
            size = "2G";
            content = {
              type = "swap";
            };
          };
          root = { # Logical Volume = "root", /dev/vg1/root
            size = "100%FREE"; # Use the remaining space in the Volume Group
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
