clear all

%Läs av bakgrund-filen
fid = fopen('Bakgrund.lst', 'r');
data = textscan(fid, '%f %f');
fclose(fid);
bakgrund_data = data{2};

%Hitta medelvärde för bakgrundstrålnignen
summa_bakgrund = 0;
for i = 1:181
    summa_bakgrund = summa_bakgrund + bakgrund_data(i);
end
genomsnitt_bakgrund = summa_bakgrund/181;

%Läs av Detektor2-filen
fid = fopen('Detektor2.lst', 'r');
data = textscan(fid, '%f %f');
fclose(fid);
detektor_data = data{2};

%Subtrahera medelvärdet av bakrundstrålningen från detektorn
for i = 1:181
    detektor_data(i) = detektor_data(i) - genomsnitt_bakgrund;
end

%Index för första negativa variabeln: 118

%Skapa plot
detektor_data_y = detektor_data(1:117);
log_detektor_data_y = log(detektor_data_y);
tid_vektor = 0:5:580;

plot(tid_vektor, log_detektor_data_y);
hold on;
y_error = sqrt(detektor_data_y);
log_error = y_error ./ detektor_data_y;
errorbar(tid_vektor, log_detektor_data_y, log_error, 'k', 'LineStyle', 'none', 'CapSize', 10);


k = (log_detektor_data_y(13) - log_detektor_data_y(1))/(60);
m = log_detektor_data_y(1);
linear_y = k*tid_vektor(1:70) + m;
plot(tid_vektor(1:70), linear_y)

j = (log_detektor_data_y(114) - log_detektor_data_y(40))/(365);
l = log_detektor_data_y(40) - j*tid_vektor(40);
linear_y = j*tid_vektor(1:117) + l;
plot(tid_vektor(1:117), linear_y)

xlabel('Tid(s)', 'FontSize', 30);
ylabel('ln(N(silver) - N(bakgr.))', 'FontSize', 30);
axis([0 565 0 7]);  % [xmin xmax ymin ymax]
legend('Observerad data','Feluppskattning','k = -0.0218','k = -0.0048', 'FontSize', 14);
ax = gca;  % Get current axis
ax.XAxis.FontSize = 25;  % X-axis tick label font size
ax.YAxis.FontSize = 25;  % Y-axis tick label font size