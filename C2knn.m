function [ClassAccu,CrossVal] = C2knn(X,Y,col, knn, app)
%% Classification Using k-Nearest Neighbours
% Input parameters
%    X   - pattern matrix
%    Y   - target values (classes)
%    col - color vector
% Output parameters
%    ClassAccu - classification accuracy 
%    CrossVal  - cross validation error

%   kdt=menu(' NEAREST NEIGHBOURS','3','5','7','9','10')
%   if kdt==1; knn=3;
%     elseif kdt==2; knn=5;
%         elseif kdt==3; knn=7;
%             elseif kdt==4; knn=9;
%                 elseif kdt==5; knn=10;
%   end

  % figure(2); set(2,'Units','Normal','Position',[0.5 0.55 0.25 0.35]);
  % scatter(app.UIAxes5,app.data_matrix(:,1),  app.data_matrix(:,2), 50, app.col(app.labels, :));
    ax = app.UIAxes7;
    cla(ax);
    xlabel(ax, 'Normalized Feature 1'); ylabel(ax, 'Normalized Feature 2');
    scatter(ax, X(:,1),X(:,2),50,app.col(Y, :), 'LineWidth',2); 
    % xlim(ax, 'manual')
    % grid on;
    %v=axis; 
    N=length(Y);
    hhh=get(ax,'children'); 
    %lgd=legend; 
    %set(lgd,'AutoUpdate','off' );
    %un_labels = unique(Y);
    TPTN=0;
 % (i) ACCURACY EVALUATION
    for i=1:N
      newpoint =X(i,:);
        h1=line(ax, newpoint(1),newpoint(2),'marker','x','color','k','markersize',10,'linewidth',2);
      [n,d] = knnsearch(X,newpoint,'k',knn);
        h2=line(ax, X(n,1),X(n,2),'color',[0 0 0],'marker','o','linestyle','none','markersize',15,'LineWidth',1);
      ctr=newpoint-d(end); diameter=2*d(end); % Circle around the knn neighbors
        h=rectangle(ax, 'position',[ctr,diameter,diameter],'curvature',[1 1],'linestyle',':');
      tabulate(Y(n));
      ttt=tabulate(Y(n(1,:))); [M1,N1]=size(ttt);
        tx=ttt(:,2); [i2,j2]=max(tx); YP=ttt(j2,1); YPC=sum(double(YP));
        if YPC==sum(double(Y(i))), TPTN=TPTN+1; end; pause(0.5); 
        if i<N; delete(h1); delete(h2); delete(h); end
    end
    
    ClassAccu=TPTN/N*100; NC=0;
% (ii) CROSS VALIDATION: one-out-leave  
  for i=1:N
    newpoint =X(i,:); XV=X([1:i-1,i+1:N],:); YV=Y([1:i-1,i+1:N],:);  
    [n,d] = knnsearch(XV,newpoint,'k',knn);
    ttt=tabulate(YV(n(1,:))); [M1,N1]=size(ttt);
      tx=ttt(:,2); [i2,j2]=max(tx); YP=ttt(j2,1); YPC=sum(double(YP));
      if YPC~=sum(double(Y(i))), NC=NC+1; end
  end
  CrossVal=NC/N*100;
  % decision surface
  
  model = fitcknn(X,Y, 'NumNeighbors', knn);
  xrange = xlim(ax);
  yrange = ylim(ax);
  x1range = xrange(1):.1:xrange(2);
  x2range = yrange(1):.1:yrange(2);
  [xx1, xx2] = meshgrid(x1range,x2range);
  XGrid = [xx1(:) xx2(:)];
  predicted = predict(model,XGrid);
  hold(ax, 'on');
  scatter(ax, xx1(:), xx2(:), 40 ,app.col(predicted, :),'filled');
  scatter(ax, X(:,1),X(:,2),100, 'w', 'filled'); 
  scatter(ax, X(:,1),X(:,2),50,app.col(Y, :), 'LineWidth',2);
  hold(ax, 'off');
  % hold(ax, 'on');
  title(ax, ['KNN: CLASSIFICATION ACCURACY: ',num2str(round(ClassAccu*10)/10), '\newline',...
         '    CROSS VALIDATION ERROR: ',num2str(round(CrossVal*10)/10)]); 
  
  
end

