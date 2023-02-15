# Hte cssl processing

## 0. Set up directory. 

Species directory already establishes, created directories `fq_fp1`, `fq_fp1_clmp`, `fq_fp1_clmp_fp2`, `fq_fp1_clmp_fp2_fqscrn`, and `fq_fp1_clmp_fp2_fqscrn_rprd`.

## 1. Download data.

All data not present, only 54 Albatross. Evidence that the initial download was interrupted. There are 218 libraries in the decode file. No duplicates, all files and lines are unique. `Hta02067*1.fq.gz` was deleted, only had `*1.fq.gz`.  

## 2. Proofread the decode files.

File names were changed from `_Ex1` to `-Ex1-cssl`. 

## 3. Edit the decode file.

File names were changed from `_Ex1` to `-Ex1-cssl`. 

## 4. Perform a renaming dry run.

<details><summary>Expand for output. </summary>
<p>

```bash 
wahab-01:/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/hypoatherina_temminckii/fq_raw> bash ../../../pire_fq_gz_processing/renameFQGZ.bash Hte_CaptureLibraries_SequenceNameDecode.tsv

decode file read into memory
rename not specified, original and new file names will be printed to screen
bash renameFQGZ.bash Hte_CaptureLibraries_SequenceNameDecode.tsv

if you want to rename then bash renameFQGZ.bash Hte_CaptureLibraries_SequenceNameDecode.tsv rename

writing original file names to file, origFileNames.txt...
writing newFileNames.txt...
editing newFileNames.txt...
preview of orig and new R1 file names...
HtA02001_CKDL220001125-1a-AK9141-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_001-Ex1-cssl.1.fq.gz
HtA02002_CKDL220001125-1a-AK3905-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_002-Ex1-cssl.1.fq.gz
HtA02003_CKDL220001125-1a-AK7761-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_003-Ex1-cssl.1.fq.gz
HtA02004_CKDL220001125-1a-5UDI298-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_004-Ex1-cssl.1.fq.gz
HtA02005_CKDL220001125-1a-5UDI298-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_005-Ex1-cssl.1.fq.gz
HtA02006_CKDL220001125-1a-AK9142-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_006-Ex1-cssl.1.fq.gz
HtA02007_CKDL220001125-1a-AK9142-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_007-Ex1-cssl.1.fq.gz
HtA02008_CKDL220001125-1a-AK8410-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_008-Ex1-cssl.1.fq.gz
HtA02010_CKDL220001125-1a-AK7759-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_010-Ex1-cssl.1.fq.gz
HtA02011_CKDL220001125-1a-AK6881-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_011-Ex1-cssl.1.fq.gz
HtA02012_CKDL220001125-1a-AK6260-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_012-Ex1-cssl.1.fq.gz
HtA02013_CKDL220001125-1a-AK9141-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_013-Ex1-cssl.1.fq.gz
HtA02014_CKDL220001125-1a-AK3905-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_014-Ex1-cssl.1.fq.gz
HtA02015_CKDL220001125-1a-AK7761-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_015-Ex1-cssl.1.fq.gz
HtA02017_CKDL220001125-1a-5UDI298-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_017-Ex1-cssl.1.fq.gz
HtA02019_CKDL220001125-1a-AK9142-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_019-Ex1-cssl.1.fq.gz
HtA02020_CKDL220001125-1a-AK8410-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_020-Ex1-cssl.1.fq.gz
HtA02021_CKDL220001125-1a-AK8587-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_021-Ex1-cssl.1.fq.gz
HtA02022_CKDL220001125-1a-AK7759-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_022-Ex1-cssl.1.fq.gz
HtA02023_CKDL220001125-1a-AK6881-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_023-Ex1-cssl.1.fq.gz
HtA02024_CKDL220001125-1a-AK6260-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_024-Ex1-cssl.1.fq.gz
HtA02025_CKDL220001125-1a-AK9141-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_025-Ex1-cssl.1.fq.gz
HtA02026_CKDL220001125-1a-AK3905-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_026-Ex1-cssl.1.fq.gz
HtA02027_CKDL220001125-1a-AK7761-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_027-Ex1-cssl.1.fq.gz
HtA02029_CKDL220001125-1a-5UDI298-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_029-Ex1-cssl.1.fq.gz
HtA02030_CKDL220001125-1a-AK9142-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_030-Ex1-cssl.1.fq.gz
HtA02031_CKDL220001125-1a-AK8410-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_031-Ex1-cssl.1.fq.gz
HtA02032_CKDL220001125-1a-AK8410-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_032-Ex1-cssl.1.fq.gz
HtA02033_CKDL220001125-1a-AK8587-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_033-Ex1-cssl.1.fq.gz
HtA02034_CKDL220001125-1a-AK7759-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_034-Ex1-cssl.1.fq.gz
HtA02035_CKDL220001125-1a-AK6881-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_035-Ex1-cssl.1.fq.gz
HtA02036_CKDL220001125-1a-AK6260-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_036-Ex1-cssl.1.fq.gz
HtA02037_CKDL220001125-1a-AK9141-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_037-Ex1-cssl.1.fq.gz
HtA02038_CKDL220001125-1a-AK3905-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_038-Ex1-cssl.1.fq.gz
HtA02039_CKDL220001125-1a-AK7761-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_039-Ex1-cssl.1.fq.gz
HtA02041_CKDL220001125-1a-5UDI298-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_041-Ex1-cssl.1.fq.gz
HtA02044_CKDL220001125-1a-AK8587-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_044-Ex1-cssl.1.fq.gz
HtA02045_CKDL220001125-1a-AK8587-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_045-Ex1-cssl.1.fq.gz
HtA02046_CKDL220001125-1a-AK7759-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_046-Ex1-cssl.1.fq.gz
HtA02047_CKDL220001125-1a-AK6881-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_047-Ex1-cssl.1.fq.gz
HtA02048_CKDL220001125-1a-AK6260-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_048-Ex1-cssl.1.fq.gz
HtA02049_CKDL220001125-1a-AK9141-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_049-Ex1-cssl.1.fq.gz
HtA02050_CKDL220001125-1a-AK3905-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_050-Ex1-cssl.1.fq.gz
HtA02051_CKDL220001125-1a-AK7761-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_051-Ex1-cssl.1.fq.gz
HtA02054_CKDL220001125-1a-AK9142-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_054-Ex1-cssl.1.fq.gz
HtA02055_CKDL220001125-1a-AK8410-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_055-Ex1-cssl.1.fq.gz
HtA02056_CKDL220001125-1a-AK8587-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_056-Ex1-cssl.1.fq.gz
HtA02057_CKDL220001125-1a-AK7759-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_057-Ex1-cssl.1.fq.gz
HtA02058_CKDL220001125-1a-AK6881-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_058-Ex1-cssl.1.fq.gz
HtA02059_CKDL220001125-1a-AK6260-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_059-Ex1-cssl.1.fq.gz
HtA02060_CKDL220001125-1a-AK7010-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_060-Ex1-cssl.1.fq.gz
HtA02061_CKDL220001125-1a-AK9141-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_061-Ex1-cssl.1.fq.gz
HtA02062_CKDL220001125-1a-AK3905-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_062-Ex1-cssl.1.fq.gz
HtA02063_CKDL220001125-1a-AK7761-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_063-Ex1-cssl.1.fq.gz
preview of orig and new R2 file names...
HtA02001_CKDL220001125-1a-AK9141-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_001-Ex1-cssl.2.fq.gz
HtA02002_CKDL220001125-1a-AK3905-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_002-Ex1-cssl.2.fq.gz
HtA02003_CKDL220001125-1a-AK7761-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_003-Ex1-cssl.2.fq.gz
HtA02004_CKDL220001125-1a-5UDI298-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_004-Ex1-cssl.2.fq.gz
HtA02005_CKDL220001125-1a-5UDI298-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_005-Ex1-cssl.2.fq.gz
HtA02006_CKDL220001125-1a-AK9142-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_006-Ex1-cssl.2.fq.gz
HtA02007_CKDL220001125-1a-AK9142-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_007-Ex1-cssl.2.fq.gz
HtA02008_CKDL220001125-1a-AK8410-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_008-Ex1-cssl.2.fq.gz
HtA02010_CKDL220001125-1a-AK7759-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_010-Ex1-cssl.2.fq.gz
HtA02011_CKDL220001125-1a-AK6881-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_011-Ex1-cssl.2.fq.gz
HtA02012_CKDL220001125-1a-AK6260-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_012-Ex1-cssl.2.fq.gz
HtA02013_CKDL220001125-1a-AK9141-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_013-Ex1-cssl.2.fq.gz
HtA02014_CKDL220001125-1a-AK3905-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_014-Ex1-cssl.2.fq.gz
HtA02015_CKDL220001125-1a-AK7761-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_015-Ex1-cssl.2.fq.gz
HtA02017_CKDL220001125-1a-5UDI298-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_017-Ex1-cssl.2.fq.gz
HtA02019_CKDL220001125-1a-AK9142-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_019-Ex1-cssl.2.fq.gz
HtA02020_CKDL220001125-1a-AK8410-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_020-Ex1-cssl.2.fq.gz
HtA02021_CKDL220001125-1a-AK8587-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_021-Ex1-cssl.2.fq.gz
HtA02022_CKDL220001125-1a-AK7759-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_022-Ex1-cssl.2.fq.gz
HtA02023_CKDL220001125-1a-AK6881-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_023-Ex1-cssl.2.fq.gz
HtA02024_CKDL220001125-1a-AK6260-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_024-Ex1-cssl.2.fq.gz
HtA02025_CKDL220001125-1a-AK9141-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_025-Ex1-cssl.2.fq.gz
HtA02026_CKDL220001125-1a-AK3905-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_026-Ex1-cssl.2.fq.gz
HtA02027_CKDL220001125-1a-AK7761-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_027-Ex1-cssl.2.fq.gz
HtA02029_CKDL220001125-1a-5UDI298-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_029-Ex1-cssl.2.fq.gz
HtA02030_CKDL220001125-1a-AK9142-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_030-Ex1-cssl.2.fq.gz
HtA02031_CKDL220001125-1a-AK8410-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_031-Ex1-cssl.2.fq.gz
HtA02032_CKDL220001125-1a-AK8410-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_032-Ex1-cssl.2.fq.gz
HtA02033_CKDL220001125-1a-AK8587-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_033-Ex1-cssl.2.fq.gz
HtA02034_CKDL220001125-1a-AK7759-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_034-Ex1-cssl.2.fq.gz
HtA02035_CKDL220001125-1a-AK6881-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_035-Ex1-cssl.2.fq.gz
HtA02036_CKDL220001125-1a-AK6260-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_036-Ex1-cssl.2.fq.gz
HtA02037_CKDL220001125-1a-AK9141-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_037-Ex1-cssl.2.fq.gz
HtA02038_CKDL220001125-1a-AK3905-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_038-Ex1-cssl.2.fq.gz
HtA02039_CKDL220001125-1a-AK7761-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_039-Ex1-cssl.2.fq.gz
HtA02041_CKDL220001125-1a-5UDI298-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_041-Ex1-cssl.2.fq.gz
HtA02044_CKDL220001125-1a-AK8587-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_044-Ex1-cssl.2.fq.gz
HtA02045_CKDL220001125-1a-AK8587-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_045-Ex1-cssl.2.fq.gz
HtA02046_CKDL220001125-1a-AK7759-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_046-Ex1-cssl.2.fq.gz
HtA02047_CKDL220001125-1a-AK6881-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_047-Ex1-cssl.2.fq.gz
HtA02048_CKDL220001125-1a-AK6260-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_048-Ex1-cssl.2.fq.gz
HtA02049_CKDL220001125-1a-AK9141-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_049-Ex1-cssl.2.fq.gz
HtA02050_CKDL220001125-1a-AK3905-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_050-Ex1-cssl.2.fq.gz
HtA02051_CKDL220001125-1a-AK7761-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_051-Ex1-cssl.2.fq.gz
HtA02054_CKDL220001125-1a-AK9142-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_054-Ex1-cssl.2.fq.gz
HtA02055_CKDL220001125-1a-AK8410-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_055-Ex1-cssl.2.fq.gz
HtA02056_CKDL220001125-1a-AK8587-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_056-Ex1-cssl.2.fq.gz
HtA02057_CKDL220001125-1a-AK7759-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_057-Ex1-cssl.2.fq.gz
HtA02058_CKDL220001125-1a-AK6881-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_058-Ex1-cssl.2.fq.gz
HtA02059_CKDL220001125-1a-AK6260-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_059-Ex1-cssl.2.fq.gz
HtA02060_CKDL220001125-1a-AK7010-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_060-Ex1-cssl.2.fq.gz
HtA02061_CKDL220001125-1a-AK9141-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_061-Ex1-cssl.2.fq.gz
HtA02062_CKDL220001125-1a-AK3905-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_062-Ex1-cssl.2.fq.gz
HtA02063_CKDL220001125-1a-AK7761-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_063-Ex1-cssl.2.fq.gz
wahab-01:/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/hypoatherina_temminckii/fq_raw>
```

</p>
</details>

## 5. Rename for real 

<details><summary>Expand for output.</summary>

```bash
wahab-01:/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/hypoathewahab-01:/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/hypoatherina_temminckii/fq_raw> bash ../../../pire_fq_gz_processing/renameFQGZ.bash Hte_CaptureLibraries_SequenceNameDecode.tsv rename

decode file read into memory
rename specified, files will be renamed
Are you sure? y
bash renameFQGZ.bash Hte_CaptureLibraries_SequenceNameDecode.tsv renamewriting original file names to file, origFileNames.txt...
writing newFileNames.txt...
editing newFileNames.txt...
preview of orig and new R1 file names...
HtA02001_CKDL220001125-1a-AK9141-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_001-Ex1-cssl.1.fq.gz
HtA02002_CKDL220001125-1a-AK3905-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_002-Ex1-cssl.1.fq.gz
HtA02003_CKDL220001125-1a-AK7761-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_003-Ex1-cssl.1.fq.gz
HtA02004_CKDL220001125-1a-5UDI298-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_004-Ex1-cssl.1.fq.gz
HtA02005_CKDL220001125-1a-5UDI298-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_005-Ex1-cssl.1.fq.gz
HtA02006_CKDL220001125-1a-AK9142-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_006-Ex1-cssl.1.fq.gz
HtA02007_CKDL220001125-1a-AK9142-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_007-Ex1-cssl.1.fq.gz
HtA02008_CKDL220001125-1a-AK8410-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_008-Ex1-cssl.1.fq.gz
HtA02010_CKDL220001125-1a-AK7759-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_010-Ex1-cssl.1.fq.gz
HtA02011_CKDL220001125-1a-AK6881-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_011-Ex1-cssl.1.fq.gz
HtA02012_CKDL220001125-1a-AK6260-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_012-Ex1-cssl.1.fq.gz
HtA02013_CKDL220001125-1a-AK9141-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_013-Ex1-cssl.1.fq.gz
HtA02014_CKDL220001125-1a-AK3905-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_014-Ex1-cssl.1.fq.gz
HtA02015_CKDL220001125-1a-AK7761-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_015-Ex1-cssl.1.fq.gz
HtA02017_CKDL220001125-1a-5UDI298-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_017-Ex1-cssl.1.fq.gz
HtA02019_CKDL220001125-1a-AK9142-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_019-Ex1-cssl.1.fq.gz
HtA02020_CKDL220001125-1a-AK8410-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_020-Ex1-cssl.1.fq.gz
HtA02021_CKDL220001125-1a-AK8587-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_021-Ex1-cssl.1.fq.gz
HtA02022_CKDL220001125-1a-AK7759-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_022-Ex1-cssl.1.fq.gz
HtA02023_CKDL220001125-1a-AK6881-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_023-Ex1-cssl.1.fq.gz
HtA02024_CKDL220001125-1a-AK6260-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_024-Ex1-cssl.1.fq.gz
HtA02025_CKDL220001125-1a-AK9141-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_025-Ex1-cssl.1.fq.gz
HtA02026_CKDL220001125-1a-AK3905-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_026-Ex1-cssl.1.fq.gz
HtA02027_CKDL220001125-1a-AK7761-7UDI243_H3JWGDSX3_L3_1.fq.gz Hte-ATic_027-Ex1-cssl.1.fq.gz
HtA02029_CKDL220001125-1a-5UDI298-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_029-Ex1-cssl.1.fq.gz
HtA02030_CKDL220001125-1a-AK9142-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_030-Ex1-cssl.1.fq.gz
HtA02031_CKDL220001125-1a-AK8410-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_031-Ex1-cssl.1.fq.gz
HtA02032_CKDL220001125-1a-AK8410-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_032-Ex1-cssl.1.fq.gz
HtA02033_CKDL220001125-1a-AK8587-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_033-Ex1-cssl.1.fq.gz
HtA02034_CKDL220001125-1a-AK7759-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_034-Ex1-cssl.1.fq.gz
HtA02035_CKDL220001125-1a-AK6881-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_035-Ex1-cssl.1.fq.gz
HtA02036_CKDL220001125-1a-AK6260-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_036-Ex1-cssl.1.fq.gz
HtA02037_CKDL220001125-1a-AK9141-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_037-Ex1-cssl.1.fq.gz
HtA02038_CKDL220001125-1a-AK3905-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_038-Ex1-cssl.1.fq.gz
HtA02039_CKDL220001125-1a-AK7761-AK892_H3JWGDSX3_L3_1.fq.gz Hte-ATic_039-Ex1-cssl.1.fq.gz
HtA02041_CKDL220001125-1a-5UDI298-AK9148_H3JWGDSX3_L3_1.fq.gz Hte-ATic_041-Ex1-cssl.1.fq.gz
HtA02044_CKDL220001125-1a-AK8587-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_044-Ex1-cssl.1.fq.gz
HtA02045_CKDL220001125-1a-AK8587-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_045-Ex1-cssl.1.fq.gz
HtA02046_CKDL220001125-1a-AK7759-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_046-Ex1-cssl.1.fq.gz
HtA02047_CKDL220001125-1a-AK6881-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_047-Ex1-cssl.1.fq.gz
HtA02048_CKDL220001125-1a-AK6260-7UDI227_H3JWGDSX3_L3_1.fq.gz Hte-ATic_048-Ex1-cssl.1.fq.gz
HtA02049_CKDL220001125-1a-AK9141-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_049-Ex1-cssl.1.fq.gz
HtA02050_CKDL220001125-1a-AK3905-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_050-Ex1-cssl.1.fq.gz
HtA02051_CKDL220001125-1a-AK7761-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_051-Ex1-cssl.1.fq.gz
HtA02054_CKDL220001125-1a-AK9142-7UDI298_H3JWGDSX3_L3_1.fq.gz Hte-ATic_054-Ex1-cssl.1.fq.gz
HtA02055_CKDL220001125-1a-AK8410-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_055-Ex1-cssl.1.fq.gz
HtA02056_CKDL220001125-1a-AK8587-AK4997_H3JWGDSX3_L3_1.fq.gz Hte-ATic_056-Ex1-cssl.1.fq.gz
HtA02057_CKDL220001125-1a-AK7759-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_057-Ex1-cssl.1.fq.gz
HtA02058_CKDL220001125-1a-AK6881-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_058-Ex1-cssl.1.fq.gz
HtA02059_CKDL220001125-1a-AK6260-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_059-Ex1-cssl.1.fq.gz
HtA02060_CKDL220001125-1a-AK7010-AK33_H3JWGDSX3_L3_1.fq.gz Hte-ATic_060-Ex1-cssl.1.fq.gz
HtA02061_CKDL220001125-1a-AK9141-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_061-Ex1-cssl.1.fq.gz
HtA02062_CKDL220001125-1a-AK3905-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_062-Ex1-cssl.1.fq.gz
HtA02063_CKDL220001125-1a-AK7761-AK8544_H3JWGDSX3_L3_1.fq.gz Hte-ATic_063-Ex1-cssl.1.fq.gz
preview of orig and new R2 file names...
HtA02001_CKDL220001125-1a-AK9141-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_001-Ex1-cssl.2.fq.gz
HtA02002_CKDL220001125-1a-AK3905-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_002-Ex1-cssl.2.fq.gz
HtA02003_CKDL220001125-1a-AK7761-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_003-Ex1-cssl.2.fq.gz
HtA02004_CKDL220001125-1a-5UDI298-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_004-Ex1-cssl.2.fq.gz
HtA02005_CKDL220001125-1a-5UDI298-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_005-Ex1-cssl.2.fq.gz
HtA02006_CKDL220001125-1a-AK9142-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_006-Ex1-cssl.2.fq.gz
HtA02007_CKDL220001125-1a-AK9142-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_007-Ex1-cssl.2.fq.gz
HtA02008_CKDL220001125-1a-AK8410-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_008-Ex1-cssl.2.fq.gz
HtA02010_CKDL220001125-1a-AK7759-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_010-Ex1-cssl.2.fq.gz
HtA02011_CKDL220001125-1a-AK6881-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_011-Ex1-cssl.2.fq.gz
HtA02012_CKDL220001125-1a-AK6260-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_012-Ex1-cssl.2.fq.gz
HtA02013_CKDL220001125-1a-AK9141-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_013-Ex1-cssl.2.fq.gz
HtA02014_CKDL220001125-1a-AK3905-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_014-Ex1-cssl.2.fq.gz
HtA02015_CKDL220001125-1a-AK7761-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_015-Ex1-cssl.2.fq.gz
HtA02017_CKDL220001125-1a-5UDI298-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_017-Ex1-cssl.2.fq.gz
HtA02019_CKDL220001125-1a-AK9142-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_019-Ex1-cssl.2.fq.gz
HtA02020_CKDL220001125-1a-AK8410-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_020-Ex1-cssl.2.fq.gz
HtA02021_CKDL220001125-1a-AK8587-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_021-Ex1-cssl.2.fq.gz
HtA02022_CKDL220001125-1a-AK7759-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_022-Ex1-cssl.2.fq.gz
HtA02023_CKDL220001125-1a-AK6881-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_023-Ex1-cssl.2.fq.gz
HtA02024_CKDL220001125-1a-AK6260-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_024-Ex1-cssl.2.fq.gz
HtA02025_CKDL220001125-1a-AK9141-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_025-Ex1-cssl.2.fq.gz
HtA02026_CKDL220001125-1a-AK3905-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_026-Ex1-cssl.2.fq.gz
HtA02027_CKDL220001125-1a-AK7761-7UDI243_H3JWGDSX3_L3_2.fq.gz Hte-ATic_027-Ex1-cssl.2.fq.gz
HtA02029_CKDL220001125-1a-5UDI298-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_029-Ex1-cssl.2.fq.gz
HtA02030_CKDL220001125-1a-AK9142-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_030-Ex1-cssl.2.fq.gz
HtA02031_CKDL220001125-1a-AK8410-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_031-Ex1-cssl.2.fq.gz
HtA02032_CKDL220001125-1a-AK8410-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_032-Ex1-cssl.2.fq.gz
HtA02033_CKDL220001125-1a-AK8587-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_033-Ex1-cssl.2.fq.gz
HtA02034_CKDL220001125-1a-AK7759-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_034-Ex1-cssl.2.fq.gz
HtA02035_CKDL220001125-1a-AK6881-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_035-Ex1-cssl.2.fq.gz
HtA02036_CKDL220001125-1a-AK6260-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_036-Ex1-cssl.2.fq.gz
HtA02037_CKDL220001125-1a-AK9141-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_037-Ex1-cssl.2.fq.gz
HtA02038_CKDL220001125-1a-AK3905-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_038-Ex1-cssl.2.fq.gz
HtA02039_CKDL220001125-1a-AK7761-AK892_H3JWGDSX3_L3_2.fq.gz Hte-ATic_039-Ex1-cssl.2.fq.gz
HtA02041_CKDL220001125-1a-5UDI298-AK9148_H3JWGDSX3_L3_2.fq.gz Hte-ATic_041-Ex1-cssl.2.fq.gz
HtA02044_CKDL220001125-1a-AK8587-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_044-Ex1-cssl.2.fq.gz
HtA02045_CKDL220001125-1a-AK8587-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_045-Ex1-cssl.2.fq.gz
HtA02046_CKDL220001125-1a-AK7759-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_046-Ex1-cssl.2.fq.gz
HtA02047_CKDL220001125-1a-AK6881-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_047-Ex1-cssl.2.fq.gz
HtA02048_CKDL220001125-1a-AK6260-7UDI227_H3JWGDSX3_L3_2.fq.gz Hte-ATic_048-Ex1-cssl.2.fq.gz
HtA02049_CKDL220001125-1a-AK9141-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_049-Ex1-cssl.2.fq.gz
HtA02050_CKDL220001125-1a-AK3905-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_050-Ex1-cssl.2.fq.gz
HtA02051_CKDL220001125-1a-AK7761-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_051-Ex1-cssl.2.fq.gz
HtA02054_CKDL220001125-1a-AK9142-7UDI298_H3JWGDSX3_L3_2.fq.gz Hte-ATic_054-Ex1-cssl.2.fq.gz
HtA02055_CKDL220001125-1a-AK8410-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_055-Ex1-cssl.2.fq.gz
HtA02056_CKDL220001125-1a-AK8587-AK4997_H3JWGDSX3_L3_2.fq.gz Hte-ATic_056-Ex1-cssl.2.fq.gz
HtA02057_CKDL220001125-1a-AK7759-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_057-Ex1-cssl.2.fq.gz
HtA02058_CKDL220001125-1a-AK6881-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_058-Ex1-cssl.2.fq.gz
HtA02059_CKDL220001125-1a-AK6260-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_059-Ex1-cssl.2.fq.gz
HtA02060_CKDL220001125-1a-AK7010-AK33_H3JWGDSX3_L3_2.fq.gz Hte-ATic_060-Ex1-cssl.2.fq.gz
HtA02061_CKDL220001125-1a-AK9141-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_061-Ex1-cssl.2.fq.gz
HtA02062_CKDL220001125-1a-AK3905-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_062-Ex1-cssl.2.fq.gz
HtA02063_CKDL220001125-1a-AK7761-AK8544_H3JWGDSX3_L3_2.fq.gz Hte-ATic_063-Ex1-cssl.2.fq.gz

Last chance to back out. If the original and new file names look ok, then proceed.
Are you sure you want to rename the files? y
renaming R1 files...
renaming R2 files...
```

</p>
</details>

## 6. Make a copy of the renamed files.

Files are copying using `screen`.

## 7. Check the quality of your data.

Executed `sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report"  "fq.gz"`. Completed. 

<details><summary>Expand for MultiQC Output.</summary>

```bash
Sample Name	 % Dups	% GC	M Seqs
Hte-ATic_001-Ex1-cssl.1	93.6%	55%	0.6
Hte-ATic_001-Ex1-cssl.2	89.5%	55%	0.6
Hte-ATic_002-Ex1-cssl.1	95.5%	56%	6.6
Hte-ATic_002-Ex1-cssl.2	94.3%	56%	6.6
Hte-ATic_003-Ex1-cssl.1	95.3%	51%	10.7
Hte-ATic_003-Ex1-cssl.2	93.7%	51%	10.7
Hte-ATic_004-Ex1-cssl.1	95.2%	50%	12.6
Hte-ATic_004-Ex1-cssl.2	93.1%	50%	12.6
Hte-ATic_005-Ex1-cssl.1	94.8%	50%	11.3
Hte-ATic_005-Ex1-cssl.2	93.4%	50%	11.3
Hte-ATic_006-Ex1-cssl.1	94.9%	48%	12.8
Hte-ATic_006-Ex1-cssl.2	92.4%	49%	12.8
Hte-ATic_007-Ex1-cssl.1	94.9%	55%	9.5
Hte-ATic_007-Ex1-cssl.2	93.9%	55%	9.5
Hte-ATic_008-Ex1-cssl.1	95.0%	57%	3.1
Hte-ATic_008-Ex1-cssl.2	93.7%	57%	3.1
Hte-ATic_010-Ex1-cssl.1	94.9%	57%	3.9
Hte-ATic_010-Ex1-cssl.2	92.3%	57%	3.9
Hte-ATic_011-Ex1-cssl.1	94.6%	48%	5.0
Hte-ATic_011-Ex1-cssl.2	92.9%	48%	5.0
Hte-ATic_012-Ex1-cssl.1	95.0%	54%	5.3
Hte-ATic_012-Ex1-cssl.2	92.7%	54%	5.3
Hte-ATic_013-Ex1-cssl.1	95.2%	51%	11.4
Hte-ATic_013-Ex1-cssl.2	93.5%	52%	11.4
Hte-ATic_014-Ex1-cssl.1	94.9%	57%	4.4
Hte-ATic_014-Ex1-cssl.2	93.1%	57%	4.4
Hte-ATic_015-Ex1-cssl.1	95.0%	52%	9.9
Hte-ATic_015-Ex1-cssl.2	93.6%	52%	9.9
Hte-ATic_017-Ex1-cssl.1	94.4%	49%	6.1
Hte-ATic_017-Ex1-cssl.2	93.1%	49%	6.1
Hte-ATic_019-Ex1-cssl.1	95.2%	56%	7.5
Hte-ATic_019-Ex1-cssl.2	93.5%	56%	7.5
Hte-ATic_020-Ex1-cssl.1	94.7%	55%	9.5
Hte-ATic_020-Ex1-cssl.2	93.4%	55%	9.5
Hte-ATic_021-Ex1-cssl.1	94.7%	47%	10.3
Hte-ATic_021-Ex1-cssl.2	93.9%	47%	10.3
Hte-ATic_022-Ex1-cssl.1	95.3%	54%	8.4
Hte-ATic_022-Ex1-cssl.2	93.1%	54%	8.4
Hte-ATic_023-Ex1-cssl.1	95.5%	53%	8.4
Hte-ATic_023-Ex1-cssl.2	93.3%	53%	8.4
Hte-ATic_024-Ex1-cssl.1	95.1%	53%	6.8
Hte-ATic_024-Ex1-cssl.2	93.2%	53%	6.8
Hte-ATic_025-Ex1-cssl.1	94.9%	55%	6.8
Hte-ATic_025-Ex1-cssl.2	93.3%	55%	6.8
Hte-ATic_026-Ex1-cssl.1	94.2%	45%	104.0
Hte-ATic_026-Ex1-cssl.2	92.3%	45%	104.0
Hte-ATic_027-Ex1-cssl.1	94.0%	47%	7.2
Hte-ATic_027-Ex1-cssl.2	92.9%	47%	7.2
Hte-ATic_029-Ex1-cssl.1	95.6%	57%	12.0
Hte-ATic_029-Ex1-cssl.2	93.5%	57%	12.0
Hte-ATic_030-Ex1-cssl.1	94.3%	49%	56.7
Hte-ATic_030-Ex1-cssl.2	92.7%	50%	56.7
Hte-ATic_031-Ex1-cssl.1	94.9%	51%	8.7
Hte-ATic_031-Ex1-cssl.2	92.3%	51%	8.7
Hte-ATic_032-Ex1-cssl.1	95.2%	54%	10.0
Hte-ATic_032-Ex1-cssl.2	93.5%	54%	10.0
Hte-ATic_033-Ex1-cssl.1	94.6%	56%	9.9
Hte-ATic_033-Ex1-cssl.2	93.1%	56%	9.9
Hte-ATic_034-Ex1-cssl.1	95.1%	55%	5.5
Hte-ATic_034-Ex1-cssl.2	93.0%	55%	5.5
Hte-ATic_035-Ex1-cssl.1	95.0%	50%	9.4
Hte-ATic_035-Ex1-cssl.2	93.3%	50%	9.4
Hte-ATic_036-Ex1-cssl.1	94.7%	51%	11.5
Hte-ATic_036-Ex1-cssl.2	93.1%	51%	11.5
Hte-ATic_037-Ex1-cssl.1	95.1%	53%	7.0
Hte-ATic_037-Ex1-cssl.2	93.7%	53%	7.0
Hte-ATic_038-Ex1-cssl.1	94.0%	48%	6.7
Hte-ATic_038-Ex1-cssl.2	93.1%	48%	6.7
Hte-ATic_039-Ex1-cssl.1	95.5%	59%	15.8
Hte-ATic_039-Ex1-cssl.2	93.9%	59%	15.8
Hte-ATic_041-Ex1-cssl.1	94.5%	45%	76.4
Hte-ATic_041-Ex1-cssl.2	93.3%	45%	76.4
Hte-ATic_044-Ex1-cssl.1	94.9%	52%	8.8
Hte-ATic_044-Ex1-cssl.2	93.6%	52%	8.8
Hte-ATic_045-Ex1-cssl.1	95.3%	55%	10.4
Hte-ATic_045-Ex1-cssl.2	94.1%	56%	10.4
Hte-ATic_046-Ex1-cssl.1	95.2%	52%	8.6
Hte-ATic_046-Ex1-cssl.2	93.1%	52%	8.6
Hte-ATic_047-Ex1-cssl.1	94.6%	49%	5.3
Hte-ATic_047-Ex1-cssl.2	92.9%	49%	5.3
Hte-ATic_048-Ex1-cssl.1	94.7%	52%	6.8
Hte-ATic_048-Ex1-cssl.2	93.6%	52%	6.8
Hte-ATic_049-Ex1-cssl.1	94.5%	48%	9.0
Hte-ATic_049-Ex1-cssl.2	92.9%	48%	9.0
Hte-ATic_050-Ex1-cssl.1	94.0%	46%	12.3
Hte-ATic_050-Ex1-cssl.2	93.1%	46%	12.3
Hte-ATic_051-Ex1-cssl.1	94.3%	46%	59.2
Hte-ATic_051-Ex1-cssl.2	92.1%	46%	59.2
Hte-ATic_054-Ex1-cssl.1	95.2%	57%	9.3
Hte-ATic_054-Ex1-cssl.2	93.5%	57%	9.3
Hte-ATic_055-Ex1-cssl.1	94.8%	54%	11.0
Hte-ATic_055-Ex1-cssl.2	93.0%	54%	11.0
Hte-ATic_056-Ex1-cssl.1	94.9%	52%	10.7
Hte-ATic_056-Ex1-cssl.2	93.8%	52%	10.7
Hte-ATic_057-Ex1-cssl.1	95.3%	56%	10.4
Hte-ATic_057-Ex1-cssl.2	93.0%	56%	10.4
Hte-ATic_058-Ex1-cssl.1	94.8%	52%	8.2
Hte-ATic_058-Ex1-cssl.2	93.0%	52%	8.2
Hte-ATic_059-Ex1-cssl.1	94.9%	50%	9.1
Hte-ATic_059-Ex1-cssl.2	93.2%	50%	9.1
Hte-ATic_060-Ex1-cssl.1	95.2%	51%	11.2
Hte-ATic_060-Ex1-cssl.2	93.5%	52%	11.2
Hte-ATic_061-Ex1-cssl.1	95.3%	54%	12.1
Hte-ATic_061-Ex1-cssl.2	94.2%	54%	12.1
Hte-ATic_062-Ex1-cssl.1	95.3%	53%	7.5
Hte-ATic_062-Ex1-cssl.2	93.7%	53%	7.5
Hte-ATic_063-Ex1-cssl.1	95.3%	50%	7.9
Hte-ATic_063-Ex1-cssl.2	93.2%	50%	7.9
```

</p>
</details>

## 8. First trim.

Executed `sbatch ../../pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1`. Completed.

<details><summary>Expand for MultiQC Output.</summary>

```bash
Sample Name	% Duplication	GC content	% PF	% Adapter
Hte-ATic_001-Ex1-cssl	81.0%	54.1%	94.7%	64.3%
Hte-ATic_002-Ex1-cssl	79.2%	56.9%	98.7%	33.8%
Hte-ATic_003-Ex1-cssl	79.7%	51.2%	98.2%	40.7%
Hte-ATic_004-Ex1-cssl	78.9%	50.1%	97.8%	35.7%
Hte-ATic_005-Ex1-cssl	81.6%	49.8%	98.4%	51.3%
Hte-ATic_006-Ex1-cssl	78.9%	48.5%	97.4%	35.9%
Hte-ATic_007-Ex1-cssl	80.9%	55.7%	98.7%	45.5%
Hte-ATic_008-Ex1-cssl	78.9%	58.4%	98.0%	48.8%
Hte-ATic_010-Ex1-cssl	77.0%	57.4%	97.3%	41.1%
Hte-ATic_011-Ex1-cssl	83.1%	47.8%	97.9%	63.7%
Hte-ATic_012-Ex1-cssl	77.9%	54.8%	97.9%	42.9%
Hte-ATic_013-Ex1-cssl	80.8%	51.9%	98.3%	39.2%
Hte-ATic_014-Ex1-cssl	77.8%	58.1%	97.8%	35.6%
Hte-ATic_015-Ex1-cssl	81.3%	52.3%	98.3%	53.8%
Hte-ATic_017-Ex1-cssl	81.1%	49.1%	98.3%	59.8%
Hte-ATic_019-Ex1-cssl	81.3%	57.2%	97.9%	42.7%
Hte-ATic_020-Ex1-cssl	80.9%	55.2%	98.0%	46.7%
Hte-ATic_021-Ex1-cssl	84.4%	46.6%	98.6%	72.7%
Hte-ATic_022-Ex1-cssl	80.1%	54.2%	97.8%	46.6%
Hte-ATic_023-Ex1-cssl	80.8%	53.2%	97.8%	42.6%
Hte-ATic_024-Ex1-cssl	80.8%	53.1%	97.7%	52.5%
Hte-ATic_025-Ex1-cssl	81.3%	55.6%	97.9%	47.6%
Hte-ATic_026-Ex1-cssl	82.6%	44.8%	97.8%	46.9%
Hte-ATic_027-Ex1-cssl	81.4%	46.2%	98.2%	64.0%
Hte-ATic_029-Ex1-cssl	78.8%	57.9%	98.0%	30.7%
Hte-ATic_030-Ex1-cssl	81.9%	49.4%	98.0%	54.3%
Hte-ATic_031-Ex1-cssl	77.7%	51.4%	96.8%	36.5%
Hte-ATic_032-Ex1-cssl	80.1%	54.2%	97.9%	42.8%
Hte-ATic_033-Ex1-cssl	81.7%	57.2%	97.5%	58.6%
Hte-ATic_034-Ex1-cssl	78.8%	55.2%	97.6%	52.0%
Hte-ATic_035-Ex1-cssl	81.0%	50.4%	97.7%	56.0%
Hte-ATic_036-Ex1-cssl	81.9%	51.6%	97.9%	55.7%
Hte-ATic_037-Ex1-cssl	81.9%	53.9%	98.1%	55.4%
Hte-ATic_038-Ex1-cssl	83.0%	47.3%	98.3%	68.6%
Hte-ATic_039-Ex1-cssl	79.2%	59.7%	98.6%	32.8%
Hte-ATic_041-Ex1-cssl	83.2%	43.6%	98.1%	70.5%
Hte-ATic_044-Ex1-cssl	81.7%	52.6%	98.4%	49.5%
Hte-ATic_045-Ex1-cssl	81.5%	56.4%	98.5%	39.8%
Hte-ATic_046-Ex1-cssl	81.0%	52.1%	97.8%	50.4%
Hte-ATic_047-Ex1-cssl	83.7%	48.2%	97.2%	65.5%
Hte-ATic_048-Ex1-cssl	83.0%	52.0%	98.6%	57.8%
Hte-ATic_049-Ex1-cssl	83.2%	47.7%	98.0%	63.9%
Hte-ATic_050-Ex1-cssl	84.8%	44.4%	98.3%	78.7%
Hte-ATic_051-Ex1-cssl	83.0%	44.3%	96.7%	72.5%
Hte-ATic_054-Ex1-cssl	77.8%	57.7%	98.3%	37.9%
Hte-ATic_055-Ex1-cssl	80.8%	54.1%	97.7%	47.4%
Hte-ATic_056-Ex1-cssl	81.5%	52.8%	98.5%	51.1%
Hte-ATic_057-Ex1-cssl	79.3%	57.3%	98.0%	41.4%
Hte-ATic_058-Ex1-cssl	81.5%	52.6%	97.8%	55.0%
Hte-ATic_059-Ex1-cssl	80.8%	50.3%	97.9%	52.9%
Hte-ATic_060-Ex1-cssl	83.4%	51.7%	97.6%	50.9%
Hte-ATic_061-Ex1-cssl	82.4%	55.3%	98.5%	55.5%
Hte-ATic_062-Ex1-cssl	81.4%	53.9%	98.0%	50.5%
Hte-ATic_063-Ex1-cssl	81.5%	50.5%	97.8%	49.1%
```

</p>
</details>

## 9. Remove duplicates with clumpify.

## 9a. Remove duplicates.

`runCLUMPIFY_r1r2_array.bash` executed. Initially failed due to issue with wahab, now fixed/finished running.

## 9b. Check duplicate removal process.

`checkClumpify_EG.R` executed "Clumpify Successfully worked on all samples".

## 9c. Generate metadata on deduplicated FASTQ files.

`runMULTIQC.sbatch` executed. completed.

<details><summary>Expand for MultiQC Output.</summary>

```bash

Sample Name	% Dups	% GC	Length	M Seqs
Hte-ATic_001-Ex1-cssl.clmp.r1	46.8%	52%	120 bp	0.1
Hte-ATic_001-Ex1-cssl.clmp.r2	45.5%	53%	121 bp	0.1
Hte-ATic_002-Ex1-cssl.clmp.r1	61.8%	56%	139 bp	0.7
Hte-ATic_002-Ex1-cssl.clmp.r2	55.5%	56%	140 bp	0.7
Hte-ATic_003-Ex1-cssl.clmp.r1	63.8%	50%	136 bp	1.2
Hte-ATic_003-Ex1-cssl.clmp.r2	55.7%	50%	136 bp	1.2
Hte-ATic_004-Ex1-cssl.clmp.r1	64.7%	49%	137 bp	1.5
Hte-ATic_004-Ex1-cssl.clmp.r2	56.5%	49%	137 bp	1.5
Hte-ATic_005-Ex1-cssl.clmp.r1	54.1%	47%	131 bp	1.2
Hte-ATic_005-Ex1-cssl.clmp.r2	51.2%	47%	132 bp	1.2
Hte-ATic_006-Ex1-cssl.clmp.r1	64.1%	47%	137 bp	1.7
Hte-ATic_006-Ex1-cssl.clmp.r2	53.3%	47%	138 bp	1.7
Hte-ATic_007-Ex1-cssl.clmp.r1	54.4%	54%	134 bp	0.9
Hte-ATic_007-Ex1-cssl.clmp.r2	50.8%	54%	134 bp	0.9
Hte-ATic_008-Ex1-cssl.clmp.r1	66.1%	55%	132 bp	0.3
Hte-ATic_008-Ex1-cssl.clmp.r2	56.9%	55%	132 bp	0.3
Hte-ATic_010-Ex1-cssl.clmp.r1	63.3%	55%	134 bp	0.4
Hte-ATic_010-Ex1-cssl.clmp.r2	53.1%	55%	134 bp	0.4
Hte-ATic_011-Ex1-cssl.clmp.r1	54.0%	46%	123 bp	0.5
Hte-ATic_011-Ex1-cssl.clmp.r2	49.7%	46%	123 bp	0.5
Hte-ATic_012-Ex1-cssl.clmp.r1	62.4%	54%	134 bp	0.6
Hte-ATic_012-Ex1-cssl.clmp.r2	52.9%	54%	134 bp	0.6
Hte-ATic_013-Ex1-cssl.clmp.r1	60.6%	50%	137 bp	1.3
Hte-ATic_013-Ex1-cssl.clmp.r2	53.7%	50%	137 bp	1.3
Hte-ATic_014-Ex1-cssl.clmp.r1	61.6%	55%	136 bp	0.5
Hte-ATic_014-Ex1-cssl.clmp.r2	55.5%	56%	136 bp	0.5
Hte-ATic_015-Ex1-cssl.clmp.r1	59.7%	49%	130 bp	1.1
Hte-ATic_015-Ex1-cssl.clmp.r2	53.3%	49%	130 bp	1.1
Hte-ATic_017-Ex1-cssl.clmp.r1	52.8%	46%	127 bp	0.6
Hte-ATic_017-Ex1-cssl.clmp.r2	49.3%	46%	127 bp	0.6
Hte-ATic_019-Ex1-cssl.clmp.r1	60.1%	54%	134 bp	0.8
Hte-ATic_019-Ex1-cssl.clmp.r2	53.9%	54%	135 bp	0.8
Hte-ATic_020-Ex1-cssl.clmp.r1	55.4%	53%	132 bp	1.0
Hte-ATic_020-Ex1-cssl.clmp.r2	52.1%	53%	132 bp	1.0
Hte-ATic_021-Ex1-cssl.clmp.r1	46.4%	44%	119 bp	1.0
Hte-ATic_021-Ex1-cssl.clmp.r2	47.6%	45%	120 bp	1.0
Hte-ATic_022-Ex1-cssl.clmp.r1	63.6%	52%	133 bp	0.9
Hte-ATic_022-Ex1-cssl.clmp.r2	53.1%	52%	133 bp	0.9
Hte-ATic_023-Ex1-cssl.clmp.r1	62.3%	52%	135 bp	0.8
Hte-ATic_023-Ex1-cssl.clmp.r2	53.3%	52%	135 bp	0.8
Hte-ATic_024-Ex1-cssl.clmp.r1	57.4%	51%	129 bp	0.7
Hte-ATic_024-Ex1-cssl.clmp.r2	51.6%	51%	130 bp	0.7
Hte-ATic_025-Ex1-cssl.clmp.r1	57.9%	53%	130 bp	0.7
Hte-ATic_025-Ex1-cssl.clmp.r2	54.3%	53%	130 bp	0.7
Hte-ATic_026-Ex1-cssl.clmp.r1	47.2%	44%	135 bp	13.0
Hte-ATic_026-Ex1-cssl.clmp.r2	47.1%	44%	135 bp	13.0
Hte-ATic_027-Ex1-cssl.clmp.r1	51.8%	44%	126 bp	0.8
Hte-ATic_027-Ex1-cssl.clmp.r2	50.2%	45%	126 bp	0.8
Hte-ATic_029-Ex1-cssl.clmp.r1	66.2%	54%	139 bp	1.4
Hte-ATic_029-Ex1-cssl.clmp.r2	57.2%	54%	139 bp	1.4
Hte-ATic_030-Ex1-cssl.clmp.r1	40.9%	48%	129 bp	5.7
Hte-ATic_030-Ex1-cssl.clmp.r2	41.0%	48%	130 bp	5.7
Hte-ATic_031-Ex1-cssl.clmp.r1	66.5%	49%	136 bp	1.1
Hte-ATic_031-Ex1-cssl.clmp.r2	57.8%	49%	136 bp	1.1
Hte-ATic_032-Ex1-cssl.clmp.r1	63.4%	51%	135 bp	1.1
Hte-ATic_032-Ex1-cssl.clmp.r2	56.2%	51%	135 bp	1.1
Hte-ATic_033-Ex1-cssl.clmp.r1	51.9%	54%	126 bp	1.0
Hte-ATic_033-Ex1-cssl.clmp.r2	51.6%	54%	126 bp	1.0
Hte-ATic_034-Ex1-cssl.clmp.r1	64.2%	51%	130 bp	0.6
Hte-ATic_034-Ex1-cssl.clmp.r2	56.0%	51%	131 bp	0.6
Hte-ATic_035-Ex1-cssl.clmp.r1	67.3%	45%	130 bp	1.2
Hte-ATic_035-Ex1-cssl.clmp.r2	60.3%	45%	130 bp	1.2
Hte-ATic_036-Ex1-cssl.clmp.r1	53.6%	50%	128 bp	1.2
Hte-ATic_036-Ex1-cssl.clmp.r2	49.6%	50%	128 bp	1.2
Hte-ATic_037-Ex1-cssl.clmp.r1	58.7%	51%	129 bp	0.7
Hte-ATic_037-Ex1-cssl.clmp.r2	53.8%	51%	129 bp	0.7
Hte-ATic_038-Ex1-cssl.clmp.r1	48.2%	45%	121 bp	0.7
Hte-ATic_038-Ex1-cssl.clmp.r2	47.9%	45%	121 bp	0.7
Hte-ATic_039-Ex1-cssl.clmp.r1	60.6%	58%	138 bp	1.7
Hte-ATic_039-Ex1-cssl.clmp.r2	53.0%	58%	138 bp	1.7
Hte-ATic_041-Ex1-cssl.clmp.r1	45.5%	41%	127 bp	8.0
Hte-ATic_041-Ex1-cssl.clmp.r2	48.4%	41%	127 bp	8.0
Hte-ATic_044-Ex1-cssl.clmp.r1	55.9%	51%	131 bp	0.9
Hte-ATic_044-Ex1-cssl.clmp.r2	51.1%	51%	131 bp	0.9
Hte-ATic_045-Ex1-cssl.clmp.r1	59.0%	55%	136 bp	1.0
Hte-ATic_045-Ex1-cssl.clmp.r2	54.2%	55%	136 bp	1.0
Hte-ATic_046-Ex1-cssl.clmp.r1	62.0%	50%	132 bp	0.9
Hte-ATic_046-Ex1-cssl.clmp.r2	52.3%	50%	132 bp	0.9
Hte-ATic_047-Ex1-cssl.clmp.r1	55.8%	46%	123 bp	0.6
Hte-ATic_047-Ex1-cssl.clmp.r2	52.3%	46%	124 bp	0.6
Hte-ATic_048-Ex1-cssl.clmp.r1	55.6%	49%	127 bp	0.7
Hte-ATic_048-Ex1-cssl.clmp.r2	52.3%	49%	127 bp	0.7
Hte-ATic_049-Ex1-cssl.clmp.r1	56.9%	44%	124 bp	1.1
Hte-ATic_049-Ex1-cssl.clmp.r2	53.6%	44%	125 bp	1.1
Hte-ATic_050-Ex1-cssl.clmp.r1	45.8%	42%	117 bp	1.3
Hte-ATic_050-Ex1-cssl.clmp.r2	47.8%	42%	117 bp	1.3
Hte-ATic_051-Ex1-cssl.clmp.r1	41.1%	42%	121 bp	5.9
Hte-ATic_051-Ex1-cssl.clmp.r2	42.5%	42%	121 bp	5.9
Hte-ATic_054-Ex1-cssl.clmp.r1	59.2%	56%	137 bp	0.9
Hte-ATic_054-Ex1-cssl.clmp.r2	52.1%	56%	137 bp	0.9
Hte-ATic_055-Ex1-cssl.clmp.r1	54.8%	52%	132 bp	1.2
Hte-ATic_055-Ex1-cssl.clmp.r2	51.3%	52%	132 bp	1.2
Hte-ATic_056-Ex1-cssl.clmp.r1	54.6%	51%	132 bp	1.1
Hte-ATic_056-Ex1-cssl.clmp.r2	51.7%	51%	132 bp	1.1
Hte-ATic_057-Ex1-cssl.clmp.r1	64.2%	55%	134 bp	1.2
Hte-ATic_057-Ex1-cssl.clmp.r2	52.9%	55%	135 bp	1.2
Hte-ATic_058-Ex1-cssl.clmp.r1	59.2%	50%	128 bp	0.9
Hte-ATic_058-Ex1-cssl.clmp.r2	52.3%	50%	129 bp	0.9
Hte-ATic_059-Ex1-cssl.clmp.r1	57.8%	48%	130 bp	1.0
Hte-ATic_059-Ex1-cssl.clmp.r2	51.2%	48%	131 bp	1.0
Hte-ATic_060-Ex1-cssl.clmp.r1	57.0%	49%	131 bp	1.1
Hte-ATic_060-Ex1-cssl.clmp.r2	53.9%	49%	131 bp	1.1
Hte-ATic_061-Ex1-cssl.clmp.r1	54.9%	52%	127 bp	1.2
Hte-ATic_061-Ex1-cssl.clmp.r2	52.8%	52%	127 bp	1.2
Hte-ATic_062-Ex1-cssl.clmp.r1	61.3%	51%	130 bp	0.8
Hte-ATic_062-Ex1-cssl.clmp.r2	55.6%	52%	131 bp	0.8
Hte-ATic_063-Ex1-cssl.clmp.r1	64.2%	48%	133 bp	0.9
Hte-ATic_063-Ex1-cssl.clmp.r2	56.1%	48%	133 bp	0.9
```
  
</p>
</details>

## 10. Second trim.

`sbatch ../../pire_fq_gz_processing/runFASTP_2_cssl.sbatch` executed, completed.

## 11. Decontaminate files.

Completed, 108 files for each file type, all files accounted for. No errors.

## 12. Repair

Repairing complete.

<details><summary>Expand for MultiQC Output.</summary>

```bash
Sample Name	% Dups	% GC	Length	M Seqs
Hte-ATic_001-Ex1-cssl.clmp.fp2_repr.R1	47.9%	50%	112 bp	0.0
Hte-ATic_001-Ex1-cssl.clmp.fp2_repr.R2	46.0%	51%	112 bp	0.0
Hte-ATic_002-Ex1-cssl.clmp.fp2_repr.R1	62.5%	54%	132 bp	0.4
Hte-ATic_002-Ex1-cssl.clmp.fp2_repr.R2	56.1%	55%	133 bp	0.4
Hte-ATic_003-Ex1-cssl.clmp.fp2_repr.R1	64.8%	48%	127 bp	0.9
Hte-ATic_003-Ex1-cssl.clmp.fp2_repr.R2	57.2%	48%	127 bp	0.9
Hte-ATic_004-Ex1-cssl.clmp.fp2_repr.R1	66.4%	47%	128 bp	1.1
Hte-ATic_004-Ex1-cssl.clmp.fp2_repr.R2	58.6%	47%	127 bp	1.1
Hte-ATic_005-Ex1-cssl.clmp.fp2_repr.R1	54.1%	46%	122 bp	0.8
Hte-ATic_005-Ex1-cssl.clmp.fp2_repr.R2	50.3%	47%	123 bp	0.8
Hte-ATic_006-Ex1-cssl.clmp.fp2_repr.R1	64.8%	46%	128 bp	1.2
Hte-ATic_006-Ex1-cssl.clmp.fp2_repr.R2	55.0%	46%	127 bp	1.2
Hte-ATic_007-Ex1-cssl.clmp.fp2_repr.R1	56.4%	53%	126 bp	0.7
Hte-ATic_007-Ex1-cssl.clmp.fp2_repr.R2	51.9%	54%	127 bp	0.7
Hte-ATic_008-Ex1-cssl.clmp.fp2_repr.R1	58.1%	54%	121 bp	0.2
Hte-ATic_008-Ex1-cssl.clmp.fp2_repr.R2	54.2%	54%	122 bp	0.2
Hte-ATic_010-Ex1-cssl.clmp.fp2_repr.R1	61.3%	53%	125 bp	0.3
Hte-ATic_010-Ex1-cssl.clmp.fp2_repr.R2	57.5%	54%	126 bp	0.3
Hte-ATic_011-Ex1-cssl.clmp.fp2_repr.R1	54.0%	45%	113 bp	0.4
Hte-ATic_011-Ex1-cssl.clmp.fp2_repr.R2	50.0%	45%	114 bp	0.4
Hte-ATic_012-Ex1-cssl.clmp.fp2_repr.R1	61.8%	52%	125 bp	0.4
Hte-ATic_012-Ex1-cssl.clmp.fp2_repr.R2	53.2%	52%	125 bp	0.4
Hte-ATic_013-Ex1-cssl.clmp.fp2_repr.R1	60.6%	50%	127 bp	0.7
Hte-ATic_013-Ex1-cssl.clmp.fp2_repr.R2	54.4%	50%	128 bp	0.7
Hte-ATic_014-Ex1-cssl.clmp.fp2_repr.R1	64.7%	56%	128 bp	0.3
Hte-ATic_014-Ex1-cssl.clmp.fp2_repr.R2	54.9%	56%	130 bp	0.3
Hte-ATic_015-Ex1-cssl.clmp.fp2_repr.R1	57.8%	47%	118 bp	0.6
Hte-ATic_015-Ex1-cssl.clmp.fp2_repr.R2	53.4%	48%	118 bp	0.6
Hte-ATic_017-Ex1-cssl.clmp.fp2_repr.R1	51.5%	44%	116 bp	0.4
Hte-ATic_017-Ex1-cssl.clmp.fp2_repr.R2	48.6%	44%	116 bp	0.4
Hte-ATic_019-Ex1-cssl.clmp.fp2_repr.R1	63.9%	52%	122 bp	0.3
Hte-ATic_019-Ex1-cssl.clmp.fp2_repr.R2	53.8%	52%	124 bp	0.3
Hte-ATic_020-Ex1-cssl.clmp.fp2_repr.R1	55.9%	52%	122 bp	0.6
Hte-ATic_020-Ex1-cssl.clmp.fp2_repr.R2	52.3%	52%	123 bp	0.6
Hte-ATic_021-Ex1-cssl.clmp.fp2_repr.R1	50.2%	44%	111 bp	0.8
Hte-ATic_021-Ex1-cssl.clmp.fp2_repr.R2	49.1%	44%	112 bp	0.8
Hte-ATic_022-Ex1-cssl.clmp.fp2_repr.R1	63.6%	51%	124 bp	0.6
Hte-ATic_022-Ex1-cssl.clmp.fp2_repr.R2	54.3%	51%	124 bp	0.6
Hte-ATic_023-Ex1-cssl.clmp.fp2_repr.R1	62.9%	51%	127 bp	0.6
Hte-ATic_023-Ex1-cssl.clmp.fp2_repr.R2	54.1%	51%	127 bp	0.6
Hte-ATic_024-Ex1-cssl.clmp.fp2_repr.R1	58.7%	49%	120 bp	0.4
Hte-ATic_024-Ex1-cssl.clmp.fp2_repr.R2	53.1%	49%	120 bp	0.4
Hte-ATic_025-Ex1-cssl.clmp.fp2_repr.R1	56.9%	53%	121 bp	0.4
Hte-ATic_025-Ex1-cssl.clmp.fp2_repr.R2	52.9%	53%	123 bp	0.4
Hte-ATic_026-Ex1-cssl.clmp.fp2_repr.R1	42.9%	42%	110 bp	1.8
Hte-ATic_026-Ex1-cssl.clmp.fp2_repr.R2	43.2%	42%	111 bp	1.8
Hte-ATic_027-Ex1-cssl.clmp.fp2_repr.R1	49.0%	45%	113 bp	0.4
Hte-ATic_027-Ex1-cssl.clmp.fp2_repr.R2	47.6%	45%	114 bp	0.4
Hte-ATic_029-Ex1-cssl.clmp.fp2_repr.R1	64.7%	56%	131 bp	0.8
Hte-ATic_029-Ex1-cssl.clmp.fp2_repr.R2	55.6%	56%	132 bp	0.8
Hte-ATic_030-Ex1-cssl.clmp.fp2_repr.R1	44.0%	46%	121 bp	4.1
Hte-ATic_030-Ex1-cssl.clmp.fp2_repr.R2	42.7%	46%	122 bp	4.1
Hte-ATic_031-Ex1-cssl.clmp.fp2_repr.R1	67.7%	47%	127 bp	0.8
Hte-ATic_031-Ex1-cssl.clmp.fp2_repr.R2	59.0%	48%	126 bp	0.8
Hte-ATic_032-Ex1-cssl.clmp.fp2_repr.R1	61.8%	52%	127 bp	0.7
Hte-ATic_032-Ex1-cssl.clmp.fp2_repr.R2	56.0%	53%	128 bp	0.7
Hte-ATic_033-Ex1-cssl.clmp.fp2_repr.R1	53.2%	55%	116 bp	0.6
Hte-ATic_033-Ex1-cssl.clmp.fp2_repr.R2	51.4%	55%	119 bp	0.6
Hte-ATic_034-Ex1-cssl.clmp.fp2_repr.R1	61.1%	52%	118 bp	0.3
Hte-ATic_034-Ex1-cssl.clmp.fp2_repr.R2	58.3%	52%	118 bp	0.3
Hte-ATic_035-Ex1-cssl.clmp.fp2_repr.R1	62.9%	47%	118 bp	0.6
Hte-ATic_035-Ex1-cssl.clmp.fp2_repr.R2	58.2%	47%	118 bp	0.6
Hte-ATic_036-Ex1-cssl.clmp.fp2_repr.R1	55.0%	47%	117 bp	0.8
Hte-ATic_036-Ex1-cssl.clmp.fp2_repr.R2	50.9%	47%	117 bp	0.8
Hte-ATic_037-Ex1-cssl.clmp.fp2_repr.R1	58.0%	50%	117 bp	0.4
Hte-ATic_037-Ex1-cssl.clmp.fp2_repr.R2	54.4%	50%	118 bp	0.4
Hte-ATic_038-Ex1-cssl.clmp.fp2_repr.R1	49.7%	45%	112 bp	0.5
Hte-ATic_038-Ex1-cssl.clmp.fp2_repr.R2	48.0%	45%	113 bp	0.5
Hte-ATic_039-Ex1-cssl.clmp.fp2_repr.R1	61.6%	56%	131 bp	1.0
Hte-ATic_039-Ex1-cssl.clmp.fp2_repr.R2	52.9%	56%	132 bp	1.0
Hte-ATic_041-Ex1-cssl.clmp.fp2_repr.R1	47.5%	41%	118 bp	6.0
Hte-ATic_041-Ex1-cssl.clmp.fp2_repr.R2	48.4%	42%	119 bp	6.0
Hte-ATic_044-Ex1-cssl.clmp.fp2_repr.R1	56.6%	48%	120 bp	0.6
Hte-ATic_044-Ex1-cssl.clmp.fp2_repr.R2	52.1%	48%	121 bp	0.6
Hte-ATic_045-Ex1-cssl.clmp.fp2_repr.R1	60.6%	54%	127 bp	0.7
Hte-ATic_045-Ex1-cssl.clmp.fp2_repr.R2	55.7%	55%	129 bp	0.7
Hte-ATic_046-Ex1-cssl.clmp.fp2_repr.R1	61.9%	49%	123 bp	0.6
Hte-ATic_046-Ex1-cssl.clmp.fp2_repr.R2	53.8%	49%	122 bp	0.6
Hte-ATic_047-Ex1-cssl.clmp.fp2_repr.R1	57.0%	45%	115 bp	0.4
Hte-ATic_047-Ex1-cssl.clmp.fp2_repr.R2	53.0%	46%	115 bp	0.4
Hte-ATic_048-Ex1-cssl.clmp.fp2_repr.R1	54.1%	46%	114 bp	0.4
Hte-ATic_048-Ex1-cssl.clmp.fp2_repr.R2	51.2%	46%	115 bp	0.4
Hte-ATic_049-Ex1-cssl.clmp.fp2_repr.R1	52.5%	45%	111 bp	0.6
Hte-ATic_049-Ex1-cssl.clmp.fp2_repr.R2	49.8%	45%	113 bp	0.6
Hte-ATic_050-Ex1-cssl.clmp.fp2_repr.R1	47.6%	42%	108 bp	1.0
Hte-ATic_050-Ex1-cssl.clmp.fp2_repr.R2	47.2%	42%	109 bp	1.0
Hte-ATic_051-Ex1-cssl.clmp.fp2_repr.R1	43.7%	42%	113 bp	4.6
Hte-ATic_051-Ex1-cssl.clmp.fp2_repr.R2	43.1%	42%	113 bp	4.6
Hte-ATic_054-Ex1-cssl.clmp.fp2_repr.R1	60.4%	54%	127 bp	0.6
Hte-ATic_054-Ex1-cssl.clmp.fp2_repr.R2	53.8%	54%	128 bp	0.6
Hte-ATic_055-Ex1-cssl.clmp.fp2_repr.R1	56.6%	50%	122 bp	0.8
Hte-ATic_055-Ex1-cssl.clmp.fp2_repr.R2	52.4%	51%	123 bp	0.8
Hte-ATic_056-Ex1-cssl.clmp.fp2_repr.R1	57.2%	49%	122 bp	0.8
Hte-ATic_056-Ex1-cssl.clmp.fp2_repr.R2	53.3%	50%	123 bp	0.8
Hte-ATic_057-Ex1-cssl.clmp.fp2_repr.R1	63.6%	55%	126 bp	0.7
Hte-ATic_057-Ex1-cssl.clmp.fp2_repr.R2	53.6%	55%	126 bp	0.7
Hte-ATic_058-Ex1-cssl.clmp.fp2_repr.R1	58.6%	49%	118 bp	0.6
Hte-ATic_058-Ex1-cssl.clmp.fp2_repr.R2	52.9%	49%	119 bp	0.6
Hte-ATic_059-Ex1-cssl.clmp.fp2_repr.R1	58.4%	47%	121 bp	0.7
Hte-ATic_059-Ex1-cssl.clmp.fp2_repr.R2	52.6%	47%	121 bp	0.7
Hte-ATic_060-Ex1-cssl.clmp.fp2_repr.R1	56.8%	46%	118 bp	0.6
Hte-ATic_060-Ex1-cssl.clmp.fp2_repr.R2	53.8%	46%	119 bp	0.6
Hte-ATic_061-Ex1-cssl.clmp.fp2_repr.R1	57.8%	49%	114 bp	0.6
Hte-ATic_061-Ex1-cssl.clmp.fp2_repr.R2	54.8%	49%	115 bp	0.6
Hte-ATic_062-Ex1-cssl.clmp.fp2_repr.R1	62.1%	51%	121 bp	0.5
Hte-ATic_062-Ex1-cssl.clmp.fp2_repr.R2	56.9%	51%	122 bp	0.5
Hte-ATic_063-Ex1-cssl.clmp.fp2_repr.R1	63.6%	48%	122 bp	0.5
Hte-ATic_063-Ex1-cssl.clmp.fp2_repr.R2	56.3%	48%	121 bp	0.5
```
  
</p>
</details>
