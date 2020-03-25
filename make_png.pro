pro make_png,png_file,PM25,minX,maxX,minY,maxY,nx,ny,  $
            xcoor,ycoor,src_x,src_y,obs_x,obs_y

;-----------------------------------------------
; plot data
;-----------------------------------------------
xs=15  &  ys=15

;===== Plot Start =====
set_plot,'ps'
ps_name='.'+path_sep()+'temp.ps'
device, /times, /color, filename=ps_name, bits=8, xsize=xs, ysize=ys, /inches
!p.font = 0 & !p.charsize=1.5 & !p.charthick=1.2

TVLCT, 255, 255, 255, 254 ; White color
TVLCT, 0, 0, 0, 253       ; Black color

!P.Color = 253
!P.Background = 254


;===== Data Scaling =====
zmin = 0.0 & zmax =20. & n_color = 255. & interval = 1.
val = scale_vector(PM25, 0, n_color, minvalue=zmin, maxvalue=zmax, /nan, /double)

; User Defined Symbol
mydevice=!d.name
usersym,[-0.5,0.5,0.5,-0.5],[-0.5,-0.5,0.5,0.5],/fill
sz = 2

plot,[minX,minY],[minX,minY], xrange=[minX,maxX], yrange=[minY,maxY], POSITION=[0., 0., 1., 1.]
  
  
LOADCT, 39
for ii = 0, nx-1 do begin
for jj = 0, ny-1 DO begin
  
    if (val(ii,jj) gt 0 and val(ii,jj) lt n_color) then   $
      plots,xcoor(ii),ycoor(jj),psym=8,symsize=sz,color=long(val(ii,jj))
      
    if (val(ii,jj) gt 0 and val(ii,jj) eq n_color) then   $
      plots,xcoor(ii),ycoor(jj),psym=8,symsize=sz,color=long(n_color-1)
      
endfor
endfor

LOADCT, 0
plotsym2, 0, 2, /FILL
plots,src_x,src_y,psym=8,symsize=1
plots,obs_x,obs_y,psym=8,symsize=1

;cgColorbar, Divisions=4, Minor=5, Format='(i3)', Ticklen=-0.25, $
;  charsize=1.5,Range=[zmin,zmax],POSITION=[0.88, 0.10, 0.92, 0.90], $
;  vertical=1,right=1
  
device, /close

; using imagemagic, convert image format from PS --> PNG
convert_command = 'convert '+ps_name+' '+png_file
spawn, convert_command, /hide

file_delete, ps_name

end