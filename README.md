# Delphine HackLibrary for RO #

## Fungsi ##

* Membypass multi-login sehingga bisa login lebih dari satu bahkan dua akun dalam satu komputer.
* Hook berberapa fungsi Windows API untuk melakukan patch multi-login dan berberapa deteksi debugger (seperti IsDebuggerPresent)

## Lisensi ##
Delphine HackLibrary ini dilisensikan dengan lisensi GPLv2 yang Open Source. Anda boleh mengubah dan menggunakan kode ini secara bebas sesuai ketentuan lisensi dan segala perubahan harus anda publish source codenya.

## Download ##
Untuk dll yang sudah jadi, anda bisa lihat di [release page](https://github.com/farisss/delphine-hacklib/releases)

## Cara penggunaan dll hook ROMultiLogin ##

1. Rename library Delphin "mfc90g.dll" yang ada di folder RO ke mfc90h.dll
2. Copy file mfc90g.dll dan ROHack.dll ke folder RO kamu
3. Jalankan Client Launcher RO (Ragnarok.exe) lalu start, lakukan untuk login kedua dan berikutnya satu persatu (tidak bisa buka Ragnarok.exe sekaligus sebelum game distart).
4. Atau... Jika kamu nggak mau buka lewat launcher RO, anda bisa membukanya langsung dengan membuat batch script ini di notepad:
   
	start ragexe.exe 1rag1

Lalu save dengan file apa saja (misal OpenRO.bat) asalkan extensinya .bat dan disave ke folder RO

5. Selamat menikmati Muti login tanpa harus pakai Sandboxie atau Virtual machine :)

## Cara compile DLL ##
* HackLibrary ini dibuat dengan Borland/Embarcadero Delphi.
* Anda perlu compiler Delphi 6 keatas untuk bisa membuat DLL Proxy mfc90g.dll
* Sedangkan untuk library ROHack.dll anda harus pakai Delphi XE2 keatas, karena library Delphi Detours tidak bisa dicompile pada Delphi versi lama.

## Note ##
Gw memastikan file ini aman dan gak gw isi dengan kode yg membahayakan, untuk analisa bisa langsung cek pada source code.

## WARNING! ##
Tolong digunakan dengan bijak!
Dan tidak selamanya cara ini berhasil ;)

## 3rd party library ##
Library ini menggunakan kode dari library lain sebagai berikut:
* [Delphi Detours Library](https://github.com/MahdiSafsafi/delphi-detours-library)
* [ScaleMM2](https://github.com/andremussche/scalemm)

Regards,
Thiekus (a.k.a f4ri5s)