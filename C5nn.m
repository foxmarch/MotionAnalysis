function [ClassAccu,CrossVal] = C5nn(X,Y,col, app)
%% Classification Using Neural Networks
% Input parameters
%    X   - pattern matrix
%    Y   - target values (classes)
%    col - color vector
% Output parameters
%    ClassAccu - classification accuracy 
%    CrossVal  - cross validation error
    ax = app.UIAxes6;
    xlabel(ax, 'Normalized Feature 1'); ylabel(ax, 'Normalized Feature 2');
    scatter(ax, X(:,1),X(:,2),50,app.col(Y, :), 'LineWidth',2);
    P=X';   MN=min(X); MX=max(X); v=[MN(1) MX(1) MN(2) MX(2)]; S=max(Y);
    T=full(ind2vec(Y',S)); % Targets
    hiddenLayerSize = 10;
    net = patternnet(hiddenLayerSize); net.trainParam.epochs=50;
    net.trainParam.min_grad=1E-16; net.trainParam.max_fail=10; trainFcn='trainscg';
      net.divideParam.trainRatio = 90/100; % Setup Division of Data
      net.divideParam.valRatio = 0/100;
      net.divideParam.testRatio = 10/100;
    [net,tr] = train(net,P,T); % view(net) % Train the Network
 % (i) ACCURACY EVALUATION    
    a = net(P);                          % Test the Network
    e = gsubtract(T,a);
    performance = perform(net,T,a)
    tind = vec2ind(T); yind = vec2ind(a); N=numel(tind);
    percentErrors = sum(tind ~= yind)/N*100;
    ClassAccu=100-percentErrors; NC=0;
% (ii) CROSS VALIDATION: one-out-leave
   for i=1:N
       PV=P(:,[1:i-1,i+1:N]); TV=T(:,[1:i-1,i+1:N]); 
       PT =P(:,i);  TT=T(:,i);
       [net,tr] = train(net,PV,TV);
       a = net(PT); aind=vec2ind(a); tind=vec2ind(TT);
       if aind~=tind, NC=NC+1; end
    end
  CrossVal=NC/N*100   

  xrange = xlim(ax);
  yrange = ylim(ax);
  x1range = xrange(1):.1:xrange(2);
  x2range = yrange(1):.1:yrange(2);
  [xx1, xx2] = meshgrid(x1range,x2range);
  XGrid = [xx1(:) xx2(:)];
  predicted = net(XGrid');
  predicted = vec2ind(predicted);
  hold(ax, 'on');
  scatter(ax, xx1(:), xx2(:), 40 ,app.col(predicted, :),'filled');
  scatter(ax, X(:,1),X(:,2),100, 'w', 'filled'); 
  scatter(ax, X(:,1),X(:,2),50,app.col(Y, :), 'LineWidth',2);
  hold(ax, 'off');
   title(ax, ['NN: CLASSIFICATION ACCURACY: ',num2str(round(ClassAccu*10)/10), '\newline',...
         '    CROSS VALIDATION ERROR: ',num2str(round(CrossVal*10)/10)]);
  
end