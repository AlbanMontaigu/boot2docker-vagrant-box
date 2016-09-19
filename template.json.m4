changequote(<!,!>)
{
    "push": {
      "name": "",
      "vcs": true
    },
    "variables": {
        "ATLAS_USERNAME": "esyscmd(echo -n $ATLAS_USERNAME)",
        "ATLAS_NAME": "esyscmd(echo -n $ATLAS_NAME)",
        "B2D_BOX_VERSION": "esyscmd(echo -n $B2D_BOX_VERSION)",
        "B2D_ISO_VERSION": "esyscmd(echo -n $B2D_ISO_VERSION)",
        "B2D_ISO_URL": "esyscmd(echo -n $B2D_ISO_URL)",
        "B2D_ISO_CHECKSUM": "esyscmd(echo -n $B2D_ISO_CHECKSUM)"
    },
    "provisioners": [
        {
            "type": "shell",
            "environment_vars": [
                "B2D_ISO_URL={{user `B2D_ISO_URL`}}"
            ],
            "scripts": [
                "scripts/build-custom-iso.sh",
                "scripts/b2d-provision.sh"
            ],
            "execute_command": "{{ .Vars }} sudo -E -S sh '{{ .Path }}'"
        }
    ],
    "builders": [
        {
            "type": "virtualbox-iso",
            "vboxmanage": [
                ["modifyvm","{{.Name}}","--memory","1536"],
                ["modifyvm","{{.Name}}","--nictype1","virtio"]
            ],
            "headless": true,
            "iso_url": "{{user `B2D_ISO_URL`}}",
            "iso_checksum_type": "md5",
            "iso_checksum": "{{user `B2D_ISO_CHECKSUM`}}",
            "boot_wait": "5s",
            "guest_additions_mode": "attach",
            "guest_os_type": "Linux_64",
            "ssh_username": "docker",
            "ssh_password": "tcuser",
            "shutdown_command": "sudo poweroff"
        }
    ],
    "post-processors": [
        [{
            "type": "vagrant",
            "keep_input_artifact": false,
            "vagrantfile_template": "vagrantfile.tpl",
            "output": "boot2docker_{{.Provider}}_v{{user `B2D_BOX_VERSION`}}.box"
        },
        {
         "type": "atlas",
         "only": ["virtualbox-iso"],
         "artifact": "{{user `ATLAS_USERNAME`}}/{{user `ATLAS_NAME`}}",
         "artifact_type": "vagrant.box",
         "metadata": {
             "provider": "virtualbox",
             "version": "{{user `B2D_BOX_VERSION`}}"
         }
        }]
    ]
}
