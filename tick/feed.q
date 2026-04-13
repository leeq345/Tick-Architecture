/ q tick/feed.q 
h_tp:hopen 5010;


.z.ts:{h_tp"(.u.upd[`trade;(`timespan$2#.z.n;`symbol$2?`APPL`MSFT`AMZN`GOOGL`TSLA`META;`float$2?10000f;`long$2?100;`symbol$2?`B`S;`symbol$2?`NYSE`NASDAQ`BATS`ARCA;`char$2?.Q.a)])";h_tp"(.u.upd[`quote;(`timespan$2#.z.n;`symbol$2?`APPL`MSFT`AMZN`GOOGL`TSLA`META;`float$2?10000f;`float$2?10000f;`long$2?500;`long$2?500;`long$2?10)])"};
system"t 1000";


