/ q tick/rts.q -p 5013
system"l tick/sym.q"

h_tp:hopen 5010;

trade:([]time:`timespan$();sym:`symbol$();price:`float$();size:`long$();side:`symbol$();ex:`symbol$();uniqueId:`char$());
quote:([]time:`timespan$();sym:`symbol$();ask:`float$();bid:`float$();askSize:`long$();bidSize:`long$();mode:`long$());

lastTrade:`sym xkey 0#trade;
lastQuote:`sym xkey 0#quote;
latestSymPrice:`sym xkey 0#trade;

upd:{[t;d]
    insert[t;d];
    if[t~`trade;`latestSymPrice upsert select by sym from d];
    if[t~`trade;`lastTrade upsert select by sym from d];
    if[t~`quote;`lastQuote upsert select by sym from d];
    };

h_tp"(.u.sub[`;`])";

.u.end:{}
