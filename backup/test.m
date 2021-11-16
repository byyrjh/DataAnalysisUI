a=[];
for i=1:10000
    temp=round(100*[rand rand rand]);
    a=[a;temp];
end
[BeadsPositionTol,Tol] = uniquetol(a,10,'ByRows', true, ...
    'OutputAllIndices', true,'DataScale', [1 1 1]);
Tol_length=zeros(size(Tol));
for i=1:length(Tol)
    Tol_length(i)=length(Tol{i,1});
end
idx=find(Tol_length>1);
clusters_pointsdist=cell(length(idx),1);
clusters_points=cell(length(idx),1);
clusters_diff_vec=cell(length(idx),1);
max_dist=0;
max_single=0;
for i=1:length(idx)
cluster_temp=a(Tol{idx(i),1},:);
num_points=size(cluster_temp,1);
dist_points=[];
abs_vec=[];
    for j=1:(num_points-1)
        for k=1:(num_points-j)
            temp=sqrt(sum((cluster_temp(j,:)-cluster_temp(j+k,:)).^2));
            temp_vec=abs(cluster_temp(j,:)-cluster_temp(j+k,:));
            sum_vec=sum(temp_vec);
            temp_vec=[temp_vec,sum_vec];
            dist_points=[dist_points,temp];
            abs_vec=[abs_vec;temp_vec];
        end
    end
    diff_vec=max(max(abs_vec(:,1)),max(max(abs_vec(:,2)),max(abs_vec(:,3))));
    if diff_vec>max_single
        max_single=diff_vec;
    end
    dist_points=sort(dist_points,'descend');
    if dist_points(1)>max_dist
        max_dist=dist_points(1);
    end
    clusters_pointsdist{i,1}=dist_points;
    clusters_points{i,1}=cluster_temp;
    clusters_diff_vec{i,1}=abs_vec;
end