---------------------check serial server linux--------------------
```
dmidecode -t system
dmidecode 2.12
SMBIOS 2.8 present.

Handle 0x0100, DMI type 1, 27 bytes
System Information
        Manufacturer: HP
        Product Name: ProLiant DL360p Gen8
        Version: Not Specified
        Serial Number: SGH428L5XS      
        UUID: 30343536-3138-4753-4834-32384C355853
        Wake-up Type: Power Switch
        SKU Number: 654081-B21      
        Family: ProLiant

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
        Status: No errors detected
```
--------------------Thong tin CPU ------------------------

```
dmidecode -t processor | grep -i version
        Version:  Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz      
        Version:  Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz      
```		
--------Thong tin RAM -------------------------------------

```
dmidecode --type 17 | more
# dmidecode 2.12
SMBIOS 2.8 present.

Handle 0x1100, DMI type 17, 40 bytes
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 16384 MB
        Form Factor: DIMM
        Set: None
        Locator: PROC  1 DIMM  1 
        Bank Locator: Not Specified
        Type: DDR3
        Type Detail: Synchronous Registered (Buffered)
        Speed: 1866 MHz
        Manufacturer: HP     
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: 712383-081          
        Rank: 2
        Configured Clock Speed: 1866 MHz
        Minimum Voltage:  1.5 V
        Maximum Voltage:  1.5 V
        Configured Voltage:  1.5 V

Handle 0x1101, DMI type 17, 40 byte

[root@app02 ~]# dmidecode -t memory | grep -i "Maximum"
        Maximum Capacity: 384 GB
        Maximum Capacity: 384 GB
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
        Maximum Voltage:  Unknown
        Maximum Voltage:  Unknown
        Maximum Voltage:  1.5 V
--> count(Maximum Voltage:  1.5 V) = 8 thanh RAM
```
--------------------------------Find the power supply hardware --------------
```
[root@app02 ~]# dmidecode -t 39
# dmidecode 2.12
SMBIOS 2.8 present.

Handle 0x2700, DMI type 39, 22 bytes
System Power Supply
        Power Unit Group: 1
        Location: Not Specified
        Name: Power Supply 1
        Manufacturer: HP
        Serial Number: 5BXRE0GHL6R2LN  
        Asset Tag: Not Specified
        Model Part Number: 656362-B21                      
        Revision: Not Specified
        Max Power Capacity: 460 W
        Status: Present, Unknown
        Type: Unknown
        Input Voltage Range Switching: Unknown
        Plugged: Yes
        Hot Replaceable: Yes

Handle 0x2701, DMI type 39, 22 bytes
System Power Supply
        Power Unit Group: 1
        Location: Not Specified
        Name: Power Supply 2
        Manufacturer: HP
        Serial Number: 5BXRE0GHL6R2LU  
        Asset Tag: Not Specified
        Model Part Number: 656362-B21                      
        Revision: Not Specified
        Max Power Capacity: 460 W
        Status: Present, Unknown
        Type: Unknown
        Input Voltage Range Switching: Unknown
        Plugged: Yes
        Hot Replaceable: Yes
```
-----------------------------------------Check disk-------------------
