��    D      <              \     ]     w     �  b  �  �   �    �     �     �  R   �          *  j   6  �   �  �   �	     E
     R
  
   e
    p
     �  �   �  Q   j     �  |   <  a   �  �        �          .  .   C     r     �  Q   �  �   �  �   �  8   O  �   �  W   /  z   �       A     �   X  �   1  e     �   h  �   h  �   ]  ?  &  B   f  �  �  �   ,  L  
  (  W  f   �  R   �  E  :   �  �!    g#  �   l$  �   W%  �   �%  _  �&  �   !(    �(     �)     *     .*     C*  |  `*     �+     �+     ,  b  ,  �   -    .     !/     1/  R   G/     �/     �/  j   �/  �   !0  �   1     �1     �1  
   �1    �1     3  �   3  Q   �3     <4  |   �4  a   95  �   �5     x6     �6     �6  .   �6     �6     7  Q   7  �   b7  �   $8  8   �8  �   9  W   �9  z   :     �:  A   �:  �   �:  �   �;  e   �<  �   �<  �   �=  �   �>  ?  �?  B   �A  �  )B  �   �C  L  �D  (  �E  f    G  R   gG  E  �G  �   I    �J  �   �K  �   �L  �   tM  _  AN  �   �O    [P     {Q     �Q     �Q     �Q   Add source to Halium tree Add to local manifest Add udev rules Before installing a rootfs, you'll need one to install. Which one you choose will depend on whether your device uses CAF sources or not. To check if your device contains any CAF source (it probably does), do a ``grep -r [term]`` for all of the following terms in $BUILDDIR/device/MANUFACTURER/CODENAME. If any search returns hits, you have a CAF device:: Before we make any changes to the rootfs (which is in the next step), you'll need to remount it with write permissions. To do that, run the following command:: Before you begin, you'll want to head over to `the Halium porting guide <http://docs.halium.org/en/latest/porting/first-steps.html>`_ and get your ``systemimage`` built without errors. Once you're at the point of installing a rootfs, you can come back here. Build the image Building ubports-boot Change the rootstock link to point to UBports once the actuallyfixit PR is merged. Choose a rootfs Continue on Create a new file in ``.repo/local_manifests`` called ``ubports-boot.xml``. Add the following to the file: Download the rootstock-touch-install script from `universalsuperbox/rootstock-ng <https://github.com/universalsuperbox/rootstock-ng/tree/xenial-actuallyfixit>`_. Boot your device into recovery and run the script as follows:: Due to a `bug in the ubports-boot build scripts <https://github.com/ubports/ubports-boot/issues/3>`_, you will need to remove it from your tree before you're able to build ``hybris-boot`` again. Edit init.rc Edit kernel config Fix mounts For an example of this, see `this commit on universalsuperbox/android_device_motorola_potter <https://github.com/UniversalSuperBox/android_device_motorola_potter/commit/9b574967e3a6f07884760b418befe731ccfcb924>`_. Removing the ``wait`` flag is not required and was an accident. Get SSH access If you are looking for information on installing Ubuntu Touch on a supported device, or if you would like to check if your device is supported, please see `this page <https://ubports.com/page/get-ubuntu-touch>`_. If you share your code and build instructions, please note that you've done this. If your device does not include any CAF sources, choose `the standard rootfs <http://ci.ubports.com/job/xenial-rootfs-armhf/>`_ If your device includes any CAF sources, choose `the CAF rootfs <http://ci.ubports.com/job/xenial-7.1-caf-sudoku-rootfs/>`_. In either case, download the large ``tar.gz`` file under the "Last successful artifacts" heading. In order to install Ubuntu Touch, you will need a recovery with Busybox, such as TWRP, installed on your phone. You will also need ensure the /data partition is formatted with ext4 and does not have any encryption on it. Include in build system Install system.img and rootfs Install ubports-boot Installing Ubuntu Touch 16.04 images on Halium Make / writeable Manual clone Now that you have ubports-boot built, you can move on to :doc:`installing-16-04`. Now that you're logged in, you must create some udev rules to allow Ubuntu Touch software to access your hardware. Run the following command, replacing [codename] with your device's codename.:: Now that you've :doc:`built ubports-boot <building-ubports-boot>`, we'll use a script called ``rootstock-touch-install`` to install an Ubuntu Touch rootfs on your device. Now, just do a ``repo sync`` to download the new source. Now, reboot the device. If all has gone well, you will eventually see the Ubuntu Touch spinner followed by Unity 8. Your lock password is the same as you set for SSH. Now, remove all ``context=`` options from all block devices in the file. Save and exit. Once ubports-boot is in place, you can build it quite simply. You will also need to rebuild system.img due to our changes. Porting information Run ``breakfast`` or ``lunch``, whichever you use for your device Similar to the Halium reference rootfs, you should set your computer's IP on the newly connected RNDIS interface to ``10.15.19.100`` if you don't get one automatically. Then, run the following to access your device:: Some Android services conflict with ofono in 16.04 and will cause your device to reboot without warning, about 30-60 seconds after it boots. We will need to disable these services until the issue is resolved. Start at :doc:`building-ubports-boot` if you'd like to install the UBports Ubuntu Touch 16.04 rootfs. The android build system won't know where to find ubports-boot normally. To fix this, open the file ``BUILDDIR/build/core/main.mk`` in a text editor. Find the comment ``# Specific projects for Halium`` and change the text directly under it to match this:: The first step to this process is figuring out where your fstab actually is. For most, this is inside ``BUILDDIR/device/MANUFACTUER/CODENAME/rootdir/etc`` and it is named either ``fstab.qcom`` or ``fstab.devicename``. Open the file for editing. The first thing that needs to be done is adding the ubports-boot source to your Halium tree. You may choose to do this by adding it to your local manifests (recommended) or simply cloning it in place. The initramfs of the ubports-boot image takes a commandline parameter, ``datapart=``, which points it to the block device that is normally mounted at ``/data`` in Android. This parameter is automatically embedded into the image at build time by finding ``/data`` in your device's default fstab and using its source. Unfortunately, this source is generally a node in ``/dev/block/bootdevice/by-name`` or something else strange, which is only available in an Android initramfs. To fix this, Halium uses the fixup-mountpoints script, which you are probably familiar with by now. The password will be the one that you set while running rootstock. The script will copy and extract the files to their proper places, then allow you to set the phablet user's password. If it gets all the way to ``rebooting device`` and doesn't seem to produce any errors, it's time to continue to the next step. If something goes wrong, please get in touch with us. If your device doesn't reboot automatically, reboot it using your recovery's interface. The ubports-boot initramfs does not use the fixup-mountpoints script, nor does it put block devices in the proper place for mounting without modification. For this reason, we are going to have to edit your device's fstab. These steps  will wipe all of the data on your device. If there is anything that you would like to keep, ensure it is backed up and copied off of the device before continuing. It is not a good idea to port Ubuntu Touch using the device you rely on every day as a testing device. You will lose data. I speak from personal experience. This is a workaround for `ubports/ubports-boot #1 <https://github.com/ubports/ubports-boot/issues/1>`_ and `ubports/ubports-boot #2 <https://github.com/ubports/ubports-boot/issues/2>`_. It should not be considered a permanent fix. Be prepared to revert this later when these bugs have been fixed. This section will introduce you to some of the specifics of porting Ubuntu Touch to an Android device. This should be a little heavier on "What to do when something goes wrong" content. To confirm that your device has booted correctly, run ``dmesg -w`` and watch for "GNU/Linux device" in the output. If you instead get something similar to "ubports initrd i hit a nail", please get in contact with us so we can find out why. You may also choose to run ``watch ip link`` and look for changes in network devices. To do this, open up your device's default ``init.rc`` (this is likely init.qcom.rc or init.[codename].rc), comment out any ``import`` statements, and add ``disabled`` to services like rild, qti, and others that interface with the radio. Most of them have a ``user radio`` line. For an example, see `commit 7875b48b on UniversalSuperBox/android_device_motorola_potter <https://github.com/UniversalSuperBox/android_device_motorola_potter/commit/7875b48b5b6f240935d7f327d33128e952a3589b>`_ Ubuntu Touch requires a slightly different kernel config than Halium, including enabling Apparmor. Luckily, we have a nice script for this purpose, ``check-kernel-config``. It's included in the ubports-boot repository. Simply run it on your config as follows:: Ubuntu Touch uses Upstart rather than Systemd for its init daemon. Because of this, it is not fully Halium-compatible and is not able to use the vanilla hybris-boot that Halium produces. For this reason, we need to build ubports-boot. We'll need to install the ubports-boot image before installing an image. Reboot your phone into fastboot mode, then do the following from your Halium tree:: When your device boots, it will likely stay at the bootloader screen. However, you should also get a new network connection on the computer you have it plugged in to. We will use this to debug the system. With the file open, change the ``src``, or first attribute, of the ``/data`` mountpoint to what you put in fixup-mountpoints for ``/data``, but without the ``/block`` folder. For example, on the Moto G5 Plus, the block device is ``/dev/block/mmcblk0p54``, so I put ``/dev/mmcblk0p54`` in this place. Also change the type to ext4, if it is not already. You may also choose to clone `the ubports-boot repository <https://github.com/ubports/ubports-boot>`_ into your tree manually. It should be placed into ``BUILDDIR/halium/ubports-boot``. You may have to do this twice. It will likely fix things both times. Then, run the script without the ``-w`` flag to see if there are any more errors. If there are, fix them manually. Once finished, run the script without the ``-w`` flag one more time to make sure everything is correct. ``cd`` to your Halium BUILDDIR ``mka systemimage`` ``mka ubports-boot`` ``source build/envsetup.sh`` Project-Id-Version: UBports 1.0
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2018-01-02 20:00-0600
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: de
Language-Team: de <LL@li.org>
Plural-Forms: nplurals=2; plural=(n != 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.5.1
 Add source to Halium tree Add to local manifest Add udev rules Before installing a rootfs, you'll need one to install. Which one you choose will depend on whether your device uses CAF sources or not. To check if your device contains any CAF source (it probably does), do a ``grep -r [term]`` for all of the following terms in $BUILDDIR/device/MANUFACTURER/CODENAME. If any search returns hits, you have a CAF device:: Before we make any changes to the rootfs (which is in the next step), you'll need to remount it with write permissions. To do that, run the following command:: Before you begin, you'll want to head over to `the Halium porting guide <http://docs.halium.org/en/latest/porting/first-steps.html>`_ and get your ``systemimage`` built without errors. Once you're at the point of installing a rootfs, you can come back here. Build the image Building ubports-boot Change the rootstock link to point to UBports once the actuallyfixit PR is merged. Choose a rootfs Continue on Create a new file in ``.repo/local_manifests`` called ``ubports-boot.xml``. Add the following to the file: Download the rootstock-touch-install script from `universalsuperbox/rootstock-ng <https://github.com/universalsuperbox/rootstock-ng/tree/xenial-actuallyfixit>`_. Boot your device into recovery and run the script as follows:: Due to a `bug in the ubports-boot build scripts <https://github.com/ubports/ubports-boot/issues/3>`_, you will need to remove it from your tree before you're able to build ``hybris-boot`` again. Edit init.rc Edit kernel config Fix mounts For an example of this, see `this commit on universalsuperbox/android_device_motorola_potter <https://github.com/UniversalSuperBox/android_device_motorola_potter/commit/9b574967e3a6f07884760b418befe731ccfcb924>`_. Removing the ``wait`` flag is not required and was an accident. Get SSH access If you are looking for information on installing Ubuntu Touch on a supported device, or if you would like to check if your device is supported, please see `this page <https://ubports.com/page/get-ubuntu-touch>`_. If you share your code and build instructions, please note that you've done this. If your device does not include any CAF sources, choose `the standard rootfs <http://ci.ubports.com/job/xenial-rootfs-armhf/>`_ If your device includes any CAF sources, choose `the CAF rootfs <http://ci.ubports.com/job/xenial-7.1-caf-sudoku-rootfs/>`_. In either case, download the large ``tar.gz`` file under the "Last successful artifacts" heading. In order to install Ubuntu Touch, you will need a recovery with Busybox, such as TWRP, installed on your phone. You will also need ensure the /data partition is formatted with ext4 and does not have any encryption on it. Include in build system Install system.img and rootfs Install ubports-boot Installing Ubuntu Touch 16.04 images on Halium Make / writeable Manual clone Now that you have ubports-boot built, you can move on to :doc:`installing-16-04`. Now that you're logged in, you must create some udev rules to allow Ubuntu Touch software to access your hardware. Run the following command, replacing [codename] with your device's codename.:: Now that you've :doc:`built ubports-boot <building-ubports-boot>`, we'll use a script called ``rootstock-touch-install`` to install an Ubuntu Touch rootfs on your device. Now, just do a ``repo sync`` to download the new source. Now, reboot the device. If all has gone well, you will eventually see the Ubuntu Touch spinner followed by Unity 8. Your lock password is the same as you set for SSH. Now, remove all ``context=`` options from all block devices in the file. Save and exit. Once ubports-boot is in place, you can build it quite simply. You will also need to rebuild system.img due to our changes. Porting information Run ``breakfast`` or ``lunch``, whichever you use for your device Similar to the Halium reference rootfs, you should set your computer's IP on the newly connected RNDIS interface to ``10.15.19.100`` if you don't get one automatically. Then, run the following to access your device:: Some Android services conflict with ofono in 16.04 and will cause your device to reboot without warning, about 30-60 seconds after it boots. We will need to disable these services until the issue is resolved. Start at :doc:`building-ubports-boot` if you'd like to install the UBports Ubuntu Touch 16.04 rootfs. The android build system won't know where to find ubports-boot normally. To fix this, open the file ``BUILDDIR/build/core/main.mk`` in a text editor. Find the comment ``# Specific projects for Halium`` and change the text directly under it to match this:: The first step to this process is figuring out where your fstab actually is. For most, this is inside ``BUILDDIR/device/MANUFACTUER/CODENAME/rootdir/etc`` and it is named either ``fstab.qcom`` or ``fstab.devicename``. Open the file for editing. The first thing that needs to be done is adding the ubports-boot source to your Halium tree. You may choose to do this by adding it to your local manifests (recommended) or simply cloning it in place. The initramfs of the ubports-boot image takes a commandline parameter, ``datapart=``, which points it to the block device that is normally mounted at ``/data`` in Android. This parameter is automatically embedded into the image at build time by finding ``/data`` in your device's default fstab and using its source. Unfortunately, this source is generally a node in ``/dev/block/bootdevice/by-name`` or something else strange, which is only available in an Android initramfs. To fix this, Halium uses the fixup-mountpoints script, which you are probably familiar with by now. The password will be the one that you set while running rootstock. The script will copy and extract the files to their proper places, then allow you to set the phablet user's password. If it gets all the way to ``rebooting device`` and doesn't seem to produce any errors, it's time to continue to the next step. If something goes wrong, please get in touch with us. If your device doesn't reboot automatically, reboot it using your recovery's interface. The ubports-boot initramfs does not use the fixup-mountpoints script, nor does it put block devices in the proper place for mounting without modification. For this reason, we are going to have to edit your device's fstab. These steps  will wipe all of the data on your device. If there is anything that you would like to keep, ensure it is backed up and copied off of the device before continuing. It is not a good idea to port Ubuntu Touch using the device you rely on every day as a testing device. You will lose data. I speak from personal experience. This is a workaround for `ubports/ubports-boot #1 <https://github.com/ubports/ubports-boot/issues/1>`_ and `ubports/ubports-boot #2 <https://github.com/ubports/ubports-boot/issues/2>`_. It should not be considered a permanent fix. Be prepared to revert this later when these bugs have been fixed. This section will introduce you to some of the specifics of porting Ubuntu Touch to an Android device. This should be a little heavier on "What to do when something goes wrong" content. To confirm that your device has booted correctly, run ``dmesg -w`` and watch for "GNU/Linux device" in the output. If you instead get something similar to "ubports initrd i hit a nail", please get in contact with us so we can find out why. You may also choose to run ``watch ip link`` and look for changes in network devices. To do this, open up your device's default ``init.rc`` (this is likely init.qcom.rc or init.[codename].rc), comment out any ``import`` statements, and add ``disabled`` to services like rild, qti, and others that interface with the radio. Most of them have a ``user radio`` line. For an example, see `commit 7875b48b on UniversalSuperBox/android_device_motorola_potter <https://github.com/UniversalSuperBox/android_device_motorola_potter/commit/7875b48b5b6f240935d7f327d33128e952a3589b>`_ Ubuntu Touch requires a slightly different kernel config than Halium, including enabling Apparmor. Luckily, we have a nice script for this purpose, ``check-kernel-config``. It's included in the ubports-boot repository. Simply run it on your config as follows:: Ubuntu Touch uses Upstart rather than Systemd for its init daemon. Because of this, it is not fully Halium-compatible and is not able to use the vanilla hybris-boot that Halium produces. For this reason, we need to build ubports-boot. We'll need to install the ubports-boot image before installing an image. Reboot your phone into fastboot mode, then do the following from your Halium tree:: When your device boots, it will likely stay at the bootloader screen. However, you should also get a new network connection on the computer you have it plugged in to. We will use this to debug the system. With the file open, change the ``src``, or first attribute, of the ``/data`` mountpoint to what you put in fixup-mountpoints for ``/data``, but without the ``/block`` folder. For example, on the Moto G5 Plus, the block device is ``/dev/block/mmcblk0p54``, so I put ``/dev/mmcblk0p54`` in this place. Also change the type to ext4, if it is not already. You may also choose to clone `the ubports-boot repository <https://github.com/ubports/ubports-boot>`_ into your tree manually. It should be placed into ``BUILDDIR/halium/ubports-boot``. You may have to do this twice. It will likely fix things both times. Then, run the script without the ``-w`` flag to see if there are any more errors. If there are, fix them manually. Once finished, run the script without the ``-w`` flag one more time to make sure everything is correct. ``cd`` to your Halium BUILDDIR ``mka systemimage`` ``mka ubports-boot`` ``source build/envsetup.sh`` 