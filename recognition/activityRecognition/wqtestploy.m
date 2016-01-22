wq{1,1} = [0.1;-0.2];
wq{2,1} = [-0.2;0.4];
wq{3,1} = [0.32;0.23];
wq{4,1} = [0.2;-0.34];
wq{5,1} = [-0.5;0.8];
wq{6,1} = [-0.98;-0.12];
wq{7,1} = [-0.2;-0.3];
wq{8,1} = [-0.8;0.2];

x = [0.1 -0.2 0.32 0.2 -0.5 -0.98 -0.2 -0.8]
y = [-0.2 0.4 0.23 -0.34 0.8 -0.12 -0.3 0.2]
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};

scatter(x,y,'go');
    axis([-1.5,1.5,-1.5,1.5]);
for indEm = 1:8
        str = emotionCell{indEm};
        x0 = x(indEm)+0.03;
        y0 = y(indEm);
        text(x0,y0,str,'HorizontalAlignment','left','FontSize',12,'Color','Blue');
    end