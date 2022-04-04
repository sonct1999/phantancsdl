create Table TAODB(name varchar(20), logic_file varchar(20), os_file varchar(200),
db_size smallint, db_maxsize smallint, db_fileGrowth smallint) 
CREATE Table TAOUD(name varchar(20), logic_file varchar(20), os_file varchar(200),
db_size smallint, db_maxsize smallint, db_fileGrowth smallint) 

insert into TAODB values ('HCM','HCM','C:\HCM_OS',4,10,1)
insert into TAODB values ('HN','HN','C:\HN_OS',4,10,1)
insert into TAODB values ('CT','CT','C:\CT_OS',4,10,1)


insert into TAOUD values ('CN01','CN01','C:\CN01_OS',4,10,1)
insert into TAOUD values ('CN02','CN02','C:\CN02_OS',4,10,1)
insert into TAOUD values ('CN03','CN03','C:\CN03_OS',4,10,1)

create proc taoUDcon  
as  
-- Khai bao cac bien cuc bo trong store proc bat dau la @ va cach nhau boi dau ,  
-- Neu khai bao lai declare thi truoc do khong co dau,  
declare @c_name varchar(20),@c_logic_file varchar(20), @c_os_file varchar(50),  
@c_db_size smallint, @c_db_maxsize smallint, @c_db_fileGrowth smallint  
declare @chuoilenh varchar(200)  
-- Khai bao bien cursor khong co @  
declare cur_Taoud scroll cursor for select * from TAOUD
open cur_Taoud  
fetch first from cur_Taoud into @c_name, @c_logic_file, @c_os_file,@c_db_size, @c_db_maxsize, @c_db_fileGrowth  
while @@fetch_status=0  
begin  
 if exists(select * from master..sysdatabases where name=@c_name )  
 	exec('drop database ' + @c_name )  
 set @chuoilenh='use master create database '+@c_name+' on primary'  
 set @chuoilenh=@chuoilenh+' (name='+@c_logic_file  
 set @chuoilenh=@chuoilenh+' ,filename='''+@c_os_file+''''  
 set @chuoilenh=@chuoilenh+' ,size='+convert(varchar,@c_db_size)  
 set @chuoilenh=@chuoilenh+' ,maxsize='+convert(varchar,@c_db_maxsize)  
 set @chuoilenh=@chuoilenh+' ,filegrowth='+convert(varchar,@c_db_filegrowth)+')'  
 exec( @chuoilenh)  
 fetch next from cur_Taoud into @c_name, @c_logic_file, @c_os_file,@c_db_size, @c_db_maxsize, @c_db_fileGrowth  
end  
close cur_Taoud  
deallocate cur_Taoud  
go

EXEC taoUDcon


create proc taoDBCon  
as  
-- Khai bao cac bien cuc bo trong store proc bat dau la @ va cach nhau boi dau ,  
-- Neu khai bao lai declare thi truoc do khong co dau,  
declare @c_name varchar(20),@c_logic_file varchar(20), @c_os_file varchar(50),  
@c_db_size smallint, @c_db_maxsize smallint, @c_db_fileGrowth smallint  
declare @chuoilenh varchar(200)  
-- Khai bao bien cursor khong co @  
declare cur_Taodb scroll cursor for select * from TAODB
open cur_Taodb  
fetch first from cur_Taodb into @c_name, @c_logic_file, @c_os_file,@c_db_size, @c_db_maxsize, @c_db_fileGrowth  
while @@fetch_status=0  
begin  
 if exists(select * from master..sysdatabases where name=@c_name )  
 	exec('drop database ' + @c_name )  
 set @chuoilenh='use master create database '+@c_name+' on primary'  
 set @chuoilenh=@chuoilenh+' (name='+@c_logic_file  
 set @chuoilenh=@chuoilenh+' ,filename='''+@c_os_file+''''  
 set @chuoilenh=@chuoilenh+' ,size='+convert(varchar,@c_db_size)  
 set @chuoilenh=@chuoilenh+' ,maxsize='+convert(varchar,@c_db_maxsize)  
 set @chuoilenh=@chuoilenh+' ,filegrowth='+convert(varchar,@c_db_filegrowth)+')'  
 exec( @chuoilenh)  
 fetch next from cur_Taodb into @c_name, @c_logic_file, @c_os_file,@c_db_size, @c_db_maxsize, @c_db_fileGrowth  
end  
close cur_Taodb  
deallocate cur_Taodb  
go
EXEC taoDBCon

go
create proc phantan
as
	-- phan tan bang chinhanh
   if exists(select * from HCM.dbo.ChiNhanh )  
 	exec('drop table ' + 'HCM.dbo.ChiNhanh' ) --- nay chi de xoa khi nó đã có 
    select * into HCM.dbo.ChiNhanh from QLNV2.dbo.ChiNhanh where TenChiNhanh=N'HCM' 

	if exists(select * from HN.dbo.ChiNhanh )  
 	exec('drop table ' + 'HN.dbo.ChiNhanh' )
	select * into HN.dbo.ChiNhanh from QLNV2.dbo.ChiNhanh where TenChiNhanh=N'HN'

	if exists(select * from CT.dbo.ChiNhanh )  
 	exec('drop table ' + 'CT.dbo.ChiNhanh' )
	select * into CT.dbo.ChiNhanh from QLNV2.dbo.ChiNhanh where TenChiNhanh=N'CT'
	-- phan tan bang phong ban
	select a.* into HCM.dbo.PhongBan from QLNV2.dbo.PhongBan a, QLNV2.dbo.ChiNhanh b
		where a.MaChiNhanh = b.MaChiNhanh and TenChiNhanh = N'HCM'
	select a.* into HN.dbo.PhongBan from QLNV2.dbo.PhongBan a, QLNV2.dbo.ChiNhanh b
		where a.MaChiNhanh = b.MaChiNhanh and TenChiNhanh = N'HN'
	select a.* into CT.dbo.PhongBan from QLNV2.dbo.PhongBan a, QLNV2.dbo.ChiNhanh b
		where a.MaChiNhanh = b.MaChiNhanh and TenChiNhanh = N'CT'
		-- Phan Tan bang nhan vien
	select a.MaNV, a.TenNV,a.ChucVu, b.MaPB, c.MaChiNhanh into HCM.dbo.NhanVien from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh  and TenChiNhanh = N'HCM'
	select a.MaNV, a.TenNV,a.ChucVu, b.MaPB, c.MaChiNhanh into CT.dbo.NhanVien from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh  and TenChiNhanh = N'CT'
	select a.MaNV, a.TenNV,a.ChucVu, b.MaPB, c.MaChiNhanh into HN.dbo.NhanVien from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh  and TenChiNhanh = N'HN'
		-- Phan Tan Giam Doc
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HCM.dbo.GiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'GIAM DOC' and TenChiNhanh = N'HCM'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into CT.dbo.GiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'GIAM DOC' and TenChiNhanh = N'CT'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HN.dbo.GiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'GIAM DOC' and TenChiNhanh = N'HN'
		-- Phan tan pho giam doc
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HCM.dbo.PhoGiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'P.GIAM DOC' and TenChiNhanh = N'HCM'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into CT.dbo.PhoGiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'P.GIAM DOC' and TenChiNhanh = N'CT'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HN.dbo.PhoGiamDoc from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and ChucVu = N'P.GIAM DOC' and TenChiNhanh = N'HN'
		
		-- Phan tan Giam doc va pho giam doc
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HCM.dbo.CapCao from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and (ChucVu = N'P.GIAM DOC' or ChucVu =  N'GIAM DOC') and TenChiNhanh = N'HCM'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into CT.dbo.CapCao from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and (ChucVu = N'P.GIAM DOC' or ChucVu = N'GIAM DOC') and TenChiNhanh = N'CT'
	select a.MaNV, a.TenNV, a.ChucVu, b.MaPB, c.MaChiNhanh into HN.dbo.CapCao from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and (ChucVu = N'P.GIAM DOC' or ChucVu = N'GIAM DOC') and TenChiNhanh = N'HN'
	
	-- Tổng lương của từng phòng
	select a.MaNV, a.TenNV, b.MaPB, c.MaChiNhanh,d.LuongPhuCap into HCM.dbo.LuongNV from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c, QLNV2.dbo.Luong d
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and a.BacLuong = d.BacLuong  and TenChiNhanh = N'HCM'
	select a.MaNV, a.TenNV, b.MaPB, c.MaChiNhanh,d.LuongPhuCap into HN.dbo.LuongNV from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c, QLNV2.dbo.Luong d
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and a.BacLuong = d.BacLuong  and TenChiNhanh = N'HN'
	select a.MaNV, a.TenNV, b.MaPB, c.MaChiNhanh,d.LuongPhuCap into CT.dbo.LuongNV from QLNV2.dbo.NhanVien a, QLNV2.dbo.PhongBan b, QLNV2.dbo.ChiNhanh c, QLNV2.dbo.Luong d
		where a.MaPB = b.MaPB and b.MaChiNhanh = c.MaChiNhanh and a.BacLuong = d.BacLuong  and TenChiNhanh = N'CT'
	-- HeSoLuong cua tung chi nhanh
	select DISTINCT c.BacLuong into HCM.dbo.BacLuong from QLNV2.dbo.NhanVien a,QLNV2.dbo.PhongBan b, QLNV2.dbo.Luong c, QLNV2.dbo.ChiNhanh d
		where a.BacLuong = c.BacLuong and a.MaPB = b.MaPB and b.MaChiNhanh = d.MaChiNhanh and TenChiNhanh = N'HCM'
	select DISTINCT c.BacLuong into HN.dbo.BacLuong from QLNV2.dbo.NhanVien a,QLNV2.dbo.PhongBan b, QLNV2.dbo.Luong c, QLNV2.dbo.ChiNhanh d
		where a.BacLuong = c.BacLuong and a.MaPB = b.MaPB and b.MaChiNhanh = d.MaChiNhanh and TenChiNhanh = N'HN' 
	select DISTINCT c.BacLuong into CT.dbo.BacLuong from QLNV2.dbo.NhanVien a,QLNV2.dbo.PhongBan b, QLNV2.dbo.Luong c, QLNV2.dbo.ChiNhanh d
		where a.BacLuong = c.BacLuong and a.MaPB = b.MaPB and b.MaChiNhanh = d.MaChiNhanh and TenChiNhanh = N'CT' 
	
 exec phantan
  -- phan tan doc
   create proc phantanUD
as
   select TenNV,ngaysinh,NgayVaoLam,CMND  into CN01.DBO.UD1 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN01'


	select TenNV,ngaysinh,NgayVaoLam,CMND into CN02.DBO.UD1 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN01'
	

    select TenNV,ngaysinh,NgayVaoLam,CMND into CN03.DBO.UD1 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN03'


    select ChucVu,TRINHDO,bacluong,MASOTHUE into CN01.DBO.UD2 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN01'


    select ChucVu,TRINHDO,bacluong,MASOTHUE into CN02.DBO.UD2 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN02'


    select ChucVu,TRINHDO,bacluong,MASOTHUE  into CN03.DBO.UD2 from QLNV2.dbo.NhanVien N, QLNV.dbo.PhongBan P where N.MaPB=P.MaPB AND MaCN=N'CN03'

EXEC phantanUD


 ---- truy van csdl
 ---tên phòng, tên chi nhánh  của phòng có nhiều nhân viên nhất
 -- c1:
 drop proc cau1
 create proc cau1
 as
  
 select P.TenPB,C.TenChiNhanh from HCM.dbo.PhongBan p, HCM.dbo.ChiNhanh c where p.MaChiNhanh=c.MaChiNhanh and P.MaPB in (select TOP 1 WITH TIES a.MaPB FROM HCM.dbo.NhanVien a GROUP BY a.MaPB ORDER BY COUNT(a.MANV) DESC)
 union
 select P.TenPB,C.TenChiNhanh from HN.dbo.PhongBan p, HN.dbo.ChiNhanh c where p.MaChiNhanh=c.MaChiNhanh and P.MaPB in (select TOP 1 WITH TIES a.MaPB FROM HN.dbo.NhanVien a GROUP BY a.MaPB ORDER BY COUNT(a.MANV) DESC)
 union
 select P.TenPB,C.TenChiNhanh from CT.dbo.PhongBan p, CT.dbo.ChiNhanh c where p.MaChiNhanh=c.MaChiNhanh and P.MaPB in (select TOP 1 WITH TIES a.MaPB FROM CT.dbo.NhanVien a GROUP BY a.MaPB ORDER BY COUNT(MANV) DESC)
 
 go

 exec cau1

 -- c2:
 drop proc cau1.1
 
 alter proc cau1
 as
declare @m1 bigint, @m2 bigint, @m3 bigint
		set @m1 = (select Max(NV) as SoNV from(select COUNT(MaNV) as NV from HCM.dbo.NhanVien group by MaPB) as NV )
		set @m2 = (select Max(NV) as SoNV from(select COUNT(MaNV) as NV from HN.dbo.NhanVien group by MaPB) as NV )
		set @m3 = (select Max(NV) as SONV from(select COUNT(MaNV) as NV from CT.dbo.NhanVien group by MaPB) as NV )

   
	if (@m2>@m1 and @m2 > @m3) select top 1 c.TenPb, b.TenChiNhanh from hn.dbo.NhanVien a, hn.dbo.ChiNhanh b, hn.dbo.PhongBan c where a.MaChiNhanh = b.machinhanh and b.machinhanh = c.machinhanh group by c.tenpb, b.tenchinhanh order by count(a.manv) desc
	else
	if (@m3>@m1 and @m3 > @m2) select top 1 c.TenPb, b.TenChiNhanh from ct.dbo.NhanVien a, ct.dbo.ChiNhanh b, ct.dbo.PhongBan c where a.MaChiNhanh = b.machinhanh and b.machinhanh = c.machinhanh group by c.tenpb, b.tenchinhanh order by count(a.manv) desc
	else  select top 1 c.TenPb, b.TenChiNhanh from hcm.dbo.NhanVien a, hcm.dbo.ChiNhanh b, hcm.dbo.PhongBan c where a.MaChiNhanh = b.machinhanh and b.machinhanh = c.machinhanh group by c.tenpb, b.tenchinhanh order by count(a.manv) desc
	go

 exec cau1


-- 2	Cho biết tên lãnh đạo chi nhánh có tổng số lương nhân viên cao nhất?
-- c1:
drop proc cau2
create proc cau2

as
declare @m1 bigint, @m2 bigint, @m3 bigint

	set @m1 = (select sum(LuongPhuCap) as TongLuong from HCM.dbo.LuongNV)
	set @m2 = (select sum(LuongPhuCap) as TongLuong from HN.dbo.LuongNV)
	set @m3 = (select sum(LuongPhuCap) as TongLuong from CT.dbo.LuongNV)

	if @m2 > @m1 set @m1 = @m2
	if @m3 > @m1 set @m1 = @m3
	select a.MaNV, a.TenNV, h.TongLuong from (select sum(LuongPhuCap) as TongLuong from HCM.dbo.LuongNV) as h, HCM.dbo.LuongNV b,  HCM.dbo.CapCao a where a.MaNV = b.MaNV and ChucVu=N'GIAM DOC'  group by a.MaNV, a.TenNV, h.Tongluong having h.TongLuong = @m1
	union
	select a.MaNV, a.TenNV, h.TongLuong from (select sum(LuongPhuCap) as TongLuong from hn.dbo.LuongNV) as h, hn.dbo.LuongNV b,  hn.dbo.CapCao a where a.MaNV = b.MaNV and ChucVu=N'GIAM DOC'  group by a.MaNV, a.TenNV, h.Tongluong having h.TongLuong = @m1
	union
	select a.MaNV, a.TenNV, h.TongLuong from (select sum(LuongPhuCap) as TongLuong from ct.dbo.LuongNV) as h, ct.dbo.LuongNV b,  ct.dbo.CapCao a where a.MaNV = b.MaNV and ChucVu=N'GIAM DOC'  group by a.MaNV, a.TenNV, h.Tongluong having h.TongLuong = @m1
	
	
	exec cau2
-- c2 :
	SELECT N.TENNV FROM QLNV2.DBO.NhanVien N, QLNV2.DBO.LUONG L, QLNV2.dbo.PhongBan P, QLNV2.dbo.CHINHANH C WHERE N.bacluong=L.BACLUONG AND N.MaPB = P.MaPB AND P.MaChiNhanh=C.MAChiNhanh AND N.ChucVu = 'GIAM DOC' AND C.MaChiNhanh = (
																					SELECT TOP 1 WITH TIES C.MaChiNhanh 
																					FROM QLNV2.dbo.PhongBan P, QLNV2.dbo.LUong L, qlnv2.dbo.NhanVien N, qlnv2.dbo.CHINHANH C 
																					WHERE P.MaPB = N.MaPB AND N.bacluong=L.BacLuong AND C.MAChiNhanh=P.MaChiNhanh 
																					GROUP BY C.MAChiNhanh 
																					ORDER BY COUNT(N.bacluong)DESC
																					)
	
-- 3	Cho biết tên các nhân viên có mức lương cao thứ 2?
create proc cau3
as
declare @m1 bigint, @m2 bigint, @m3 bigint
	set @m1 = (select top 1 max(LuongPhuCap) from HCM.dbo.LuongNV group by MaNV order by max(LuongPhuCap) Desc)
	set @m2 = (select top 1 max(LuongPhuCap) from HN.dbo.LuongNV group by MaNV order by max(LuongPhuCap) Desc)
	set @m3 = (select top 1 max(LuongPhuCap) from CT.dbo.LuongNV group by MaNV order by max(LuongPhuCap) Desc)
	if @m2 > @m1 set @m2 = @m1
	if @m3 > @m1 set @m3 = @m1
declare @n1 bigint, @n2 bigint, @n3 bigint
	set @n1 = (select top 1 max(LuongPhuCap) from HCM.dbo.LuongNV group by MaNV having max(LuongPhuCap) <> @m1 order by max(LuongPhuCap) desc)
	set @n2 = (select top 1 max(LuongPhuCap) from HN.dbo.LuongNV group by MaNV having max(LuongPhuCap) <> @m2 order by max(LuongPhuCap) desc)
	set @n3 = (select top 1 max(LuongPhuCap) from CT.dbo.LuongNV group by MaNV having max(LuongPhuCap) <> @m3 order by max(LuongPhuCap) desc)
	if @n2 > @n1 set @n2 = @n1
	if @n3 > @n1 set @n3 = @n1
select a.MaNV, a.TenNV, max(LuongPhuCap) as SoLuong from HCM.dbo.LuongNV a, HCM.dbo.NhanVien b where a.MaNV = b.MaNV group by a.MaNV,a.TenNV  having max(LuongPhuCap) = @n1
union
select a.MaNV, a.TenNV, max(LuongPhuCap) as SoLuong from HN.dbo.LuongNV a, HCM.dbo.NhanVien b where a.MaNV = b.MaNV group by a.MaNV,a.TenNV  having max(LuongPhuCap) = @n1
union
select a.MaNV, a.TenNV, max(LuongPhuCap) as SoLuong from CT.dbo.LuongNV a, HCM.dbo.NhanVien b where a.MaNV = b.MaNV group by a.MaNV,a.TenNV  having max(LuongPhuCap) = @n1
exec cau3
-- 4	Chuyển nhân viên có mã số “abc” từ chi nhánh Hà Nội về chi nhánh Cần Thơ.
create proc cau4
as
begin transaction 
	insert into CT.dbo.NhanVien
	select * from HN.dbo.NhanVien where MaNV = N'NV03'
	delete from HN.dbo.NhanVien  where MaNV = N'NV03'

	insert into CT.dbo.LuongNV
	select * from HN.dbo.LuongNV where MaNV = N'NV03'
	delete from HN.dbo.LuongNV where MaNV = N'NV03'
commit;
exec cau4
-- 5	Cho biết tên chi nhánh có nhân viên tên “Phạm Thu Hương”?
drop proc cau5
create proc cau5
as 
select a.TenChiNhanh, b.TenNV from HCM.dbo.NhanVien b, HCM.dbo.ChiNhanh a where a.MaChiNhanh = b.MaChiNhanh and TenNV like '%Phan Xuan Son%'
union
select a.TenChiNhanh, b.TenNV from HN.dbo.NhanVien b, HN.dbo.ChiNhanh a where a.MaChiNhanh = b.MaChiNhanh and TenNV like '%Phan Xuan Son%'
union
select a.TenChiNhanh, b.TenNV from CT.dbo.NhanVien b, CT.dbo.ChiNhanh a where a.MaChiNhanh = b.MaChiNhanh and TenNV like '%Phan Xuan Son%'
go 
exec cau5




