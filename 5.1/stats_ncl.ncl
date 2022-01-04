;-----------------------------------------------------
; Plot temporal series and
; calculate statistics
;-----------------------------------------------------

;-----------------------------------------------------
; User specifications
;-----------------------------------------------------
load "/mnt/c/users/arthur/documents/ic/4.5/shapefile_utils.ncl" ; script usado para shapefiles
load "/mnt/c/users/arthur/documents/ic/4.5/text.ncl"




  
begin
area = (/"SJ Rio Preto","Ribeirao Preto","Aracatuba","Bauru","Araraquara","Piracicaba","Campinas","Presidente Prudente","Marilia","Assis","Itapetininga","Macro Metropolitana Paulista","Vale do Paraiba","Litoral Sul","Metropolitana de SP"/)


dird = "/mnt/c/users/arthur/documents/ic/4.7/" ;local chirps 

na = 15   ; numero de areas

fm = addfile (dird+"prec-anom.nc","r") ;chirps 
v = fm->pr
printVarSummary(v)

;---------------------------------------------------------
; Evaluate stats
; lower quartile (6), upper quartile (10)
;---------------------------------------------------------
var = new((/15,30/),float) ; (numero de areas,stats)

opt = False
do i=0,na-1
   var(i,:) = stat_dispersion(v(i,:),opt) ; essa funcao retorna 30 valores de estatisticas
end do

; para desenhar as linhas do lower and upper quartile:
; res@gsnYRefLine = (/ lower_value, upper_value /)
; ex: res@gsnYRefLine = (/ 0.0, 2.5 /)

;---------------------------------------------------------
; Writing table in txt
;---------------------------------------------------------
year = ispan(1981,2020,1)

file_F = "dados.txt"
system("/bin/rm -f "+file_F)  ; remove any pre-existing file
write_table(file_F, "w", [/"Anomalias de precipitação mm/day"/], "%s")

do j=0,na-1
  write_table(file_F, "a", [/area(j)/], "%s")
  write_table(file_F, "a", [/"Ano","Anomalia"/], "%s %s")
  write_table(file_F, "a", [/year(:),v(j,:)/],"%d %f")
end do

file_F = "estatisticas.txt"
system("/bin/rm -f "+file_F)  ; remove any pre-existing file
write_table(file_F, "w", [/"Estatisticas"/], "%s")
write_table(file_F, "a", [/"Area","Quartil de baixo","Quartil de cima"/], "%s %s %s")
write_table(file_F, "a", [/area(:),var(:,6),var(:,10)/],"%s %f %f")
  
end

