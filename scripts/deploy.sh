
#controller_id dev
#hxdrg-c5lyh-bmfna-xyae5-fv6tq-lj6mb-xsubn-spk2v-lmwxy-ww5bq-uqe

#controller_id prod
#5j56q-yerxa-yvyft-lt6dp-gasf3-gaptg-7s2og-2ecrm-u5qb7-crbc4-sae

dfx generate
dfx deps pull
dfx deps deploy  -network dev
dfx deploy -network dev