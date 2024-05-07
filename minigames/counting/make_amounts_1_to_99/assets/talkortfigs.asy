import graph;
settings.outformat="svg";
defaultpen(fontsize(11 pt));
unitsize(3/4);

usepackage("icomma");
usepackage("amsmath");
usepackage("amssymb");


real a = 46;
real b = a*((sqrt(5)+1)/2);
real sc = a/10;
real y = 0.2;
real bmarg = 0.4;
real labelscale = 2;


void db(int I=1, int J=1, int m=I, int n=J, pair sh=(0,0), pen p=white, pen p1=black, bool l=false, real ls=0.0, real opac=0.1, real y = 0){
	path b = box((0,0),sc*(1,1));
	int cnt = 0;
	for (int i = 1; i <= I; ++i){
		for (int j = 1; j <= J; ++j){
			if (i<=m || j<=n){
			filldraw(shift(sh+(0,bmarg)+(0,y*(j-1))+sc*(i-1,j-1))*b, p+opacity(opac), drawpen=p1);
			++cnt;
			}
			}
		}
		if (l == true){
			string name = "$%d$";
			string lb = format(name, cnt);
		 	label(lb,(I/2+sh.x,-ls+sh.y),S);
		 }
}
path numb = box((0,0),(a,b));

pen p1 = RGB(213, 0, 245);
pen p10 = RGB(179, 47, 68);
pen p100 = RGB(0, 197, 234);

real d = 6;
