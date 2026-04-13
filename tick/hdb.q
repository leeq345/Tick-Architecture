/q tick/hdb.q sym -p 5012
if[1>count .z.x;show"Supply directory of historical database";exit 0];
hdb:.z.x 0
@[{system"l ",x};hdb;{show "Error message - ",x;exit 0}]

selectFunc:{[tbl;sd;ed;ids]
  $[`date in cols tbl;
  select from tbl where date within (sd;ed),sym in ids;
  [res:$[.z.D within (sd;ed); select from tbl where sym in ids;0#value tbl];
    `date xcols update date:.z.D from res]] }
