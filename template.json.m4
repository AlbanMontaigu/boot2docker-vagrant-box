changequote(<!,!>)
{
    "push": {
      "name": "",
      "vcs": true
    },
    "variables": {
        "B2D_SSH_USERNAME": "docker",
        "B2D_SSH_PASSWORD": "tcuser",
        "ATLAS_USERNAME": "esyscmd(echo -n $ATLAS_USERNAME)",
        "ATLAS_NAME": "esyscmd(echo -n $ATLAS_NAME)",
        "B2D_BOX_VERSION": "esyscmd(echo -n $B2D_BOX_VERSION)",
        "B2D_ISO_VERSION": "esyscmd(echo -n $B2D_ISO_VERSION)",
        "B2D_ISO_URL": "esyscmd(echo -n $B2D_ISO_URL)",
        "B2D_ISO_CHECKSUM_TYPE": "md5",
        "B2D_ISO_CHECKSUM": "esyscmd(echo -n $B2D_ISO_CHECKSUM)"
    },
    "builders": [
        {
            "type": "virtualbox-iso",
            "name" : "x64-virtualbox",
            "headless": "true",
            "vboxmanage": [
                ["modifyvm","{{.Name}}","--memory","1536"],
            ],
            "disk_size": 100000,
            "iso_url": "{{user `B2D_ISO_URL`}}",
            "iso_checksum_type": "{{user `B2D_ISO_CHECKSUM_TYPE`}}",
            "iso_checksum": "{{user `B2D_ISO_CHECKSUM`}}",
            "boot_wait": "5s",
            "guest_additions_mode": "attach",
            "guest_os_type": "Linux_64",
            "ssh_username": "{{user `B2D_SSH_USERNAME`}}",
            "ssh_password": "{{user `B2D_SSH_PASSWORD`}}",
            "shutdown_command": "sudo poweroff"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "execute_command": "{{ .Vars }} sudo -E -S sh '{{ .Path }}'",
            "environment_vars": [
                "B2D_ISO_URL={{user `B2D_ISO_URL`}}"
            ],
            "scripts": [
                "scripts/build-custom-iso.sh",
                "scripts/b2d-provision.sh"
            ]
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
