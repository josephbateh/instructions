# Headless Wifi for Raspberry Pi

## Create wpa_supplicant.conf

wpa_supplicant.conf

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev update_config=1
country=«your_ISO-3166-1_two-letter_country_code»

```conf
network={
    ssid="«your_SSID»"
    psk="«your_PSK»"
    key_mgmt=WPA-PSK
}
```

## Create SSH File

```bash
ssh
```
