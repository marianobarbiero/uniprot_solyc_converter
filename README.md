# Uniprot Solyc Converter



## Getting Started

1 - Edit the file code.txt adding UniProt codes to be converted. The file should be like the following:
```
K4CB65
K4B3G7
```
2 - Run uniprot_solyc_converter.sh

```
./uniprot_solyc_converter.sh

```
3 - Wait until the current program is finished, and you will see:

```
Starting...
code count:  2 codes.txt
#Solyc07g005940.2.1
#Solyc01g109540.2.1
[DONE]
```

4 - Once the program finished you can find the result file:

[running_date]_result.txt
```
#Solyc07g005940.2.1#Solyc07g005940.2.1 - Vacuolar ATPase subunit H protein (AHRD V1 ***- B6SIW6_MAIZE); contains Interpro domain(s)  IPR004908  ATPase, V1 complex, subunit H
#Solyc01g109540.2.1#Solyc01g109540.2.1 - Coatomer subunit gamma (AHRD V1 ***- B6SV32_MAIZE); contains Interpro domain(s)  IPR017106  Coatomer, gamma subunit
```

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details