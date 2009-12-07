program Traffic;
type TGraph = array[1..50,1..50] of integer;	{ ���ڽӾ����ʾ��ͼ���� }
     TList  = array[0..50] of integer;		{ ���������С��������·������������ }

var a,b:TGraph;					{ ����ľ���A��B }
    n,k:integer;
    cost:integer;				{ ���ݵ��ܷ��� }

var fin,fout:text;				{ ���룬����ļ� }

procedure init;					{ ��ʼ�����̣��������A��B }
var i,j:integer;
begin
     assign(fin,'input.txt');
     reset(fin);
     assign(fout,'output.txt');
     rewrite(fout);
     readln(fin,n,k);
     for i:=1 to n do
         for j:=1 to n do read(fin,a[i,j]);
     for i:=1 to n do
         for j:=1 to n do read(fin,b[i,j]);
end;

var f,arc:TGraph;		{ fΪÿһ�����ϵ�������arcΪ��ǰͼ��ÿһ�����ķ��� }
    lnk,w:TList;

procedure work;			{ ������ }
var saturation:boolean;		{ ���ݿ�ʼ��־ }

          procedure ExpandPath(var load:integer);	{ �����С��������·��������·�������� }
          var i,j:integer;
              change:boolean;
          begin
               { ���ݵ�ǰ���ϵ���������ÿһ�����ķ��� }
               for i:=1 to n do
               for j:=1 to n do
                   if (a[i,j]>0) then			{ ǰ�� }
                      if (f[i,j]<a[i,j]) then arc[i,j]:=0	
                      else arc[i,j]:=b[i,j]
                   else
                   if (a[j,i]>0) then			{ ���� }
                      if (f[j,i]>0) and (f[j,i]<a[j,i]) then
                         arc[i,j]:=0
                      else
                      if (f[j,i]>a[j,i]) then
                         arc[i,j]:=-b[j,i]
                      else arc[i,j]:=MaxInt
                   else arc[i,j]:=MaxInt;

               for i:=1 to n do w[i]:=MaxInt;
               w[1]:=0;
               fillchar(lnk,sizeof(lnk),0);

		{ ����Ford�㷨��Ӷ���1��n�����·�� }
               repeat
                     change:=false;
                     for i:=1 to n do
                         if w[i]<>MaxInt then
                             for j:=1 to n do
                             if (arc[i,j]<>MaxInt) and (w[i]+arc[i,j]<w[j]) then
                             begin
                                  w[j]:=w[i]+arc[i,j];
                                  if a[i,j]>0 then lnk[j]:=i
                                     else lnk[j]:=-i;
                                  change:=true;
                             end;
               until not change;

               if lnk[n]=0 then
               begin load:=0; exit; end;

		{ �������·�������������ʹ���������ٶȸ��� }
               i:=n;     load:=Maxint;
               while (i<>1) do
               begin
                    j:=abs(lnk[i]);
                    if (lnk[i]>0) then
                       if (f[j,i]<a[j,i]) and (a[j,i]-f[j,i]<load) then load:=a[j,i]-f[j,i]
                          else if (f[j,i]>=a[j,i]) then saturation:=true  { ��ʼ�Ե�·���� }
				  else
                    else
                        if (f[i,j]>a[i,j]) and (f[i,j]-a[i,j]<load) then load:=f[i,j]-a[i,j]
                           else if (f[i,j]<=a[i,j]) and (f[i,j]<load) then load:=f[i,j] else;
                    i:=j;
               end;
               if load=Maxint then load:=k;
          end;

var i,j,load:integer;

begin
     cost:=0;                           saturation:=false;
     fillchar(f,sizeof(f),0);
     ExpandPath(load);			{ ����С��������·�� }
     while (load<>0) and (k>0) do
     begin
          if saturation then		{ �Ѿ���ʼ���� }
          begin
               if load>k then load:=k;	{ �ۼ����������������� }
               k:=k-load;
          end;
          i:=n;
          while (i<>1) do		{ ������·���������ص�����ֵload��������������� }
          begin
               j:=abs(lnk[i]);
               if lnk[i]>0 then
               begin
                    inc(f[j,i],load);
                    if f[j,i]>a[j,i] then
                       inc(cost,load*b[j,i]);
               end
               else begin
                         if f[i,j]>a[i,j] then
                            dec(cost,load*b[i,j]);
                         dec(f[i,j],load);
                    end;
               i:=j;
          end;
          ExpandPath(load);		{ ����С��������·�� }
     end;
end;

procedure over;			{ ������ر��ļ� }
var i,j:integer;
begin
     writeln(fout,cost);
     for i:=1 to n do
         for j:=1 to n do
         if f[i,j]>a[i,j] then writeln(fout,i,' ',j,' ',f[i,j]-a[i,j]);
     close(fin);
     close(fout);
end;

{ ������ }
begin
     init;
     work;
     over;
end.