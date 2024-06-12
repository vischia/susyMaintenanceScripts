# simple script to make fits adding systematics one by one
cardspath=$1
card=$2

# Get systematics by parametrization
pars="lnN shape"

function remove_nuis () {
  ref_card=$1
  outfolder=$2
  nuis=$3
  
  mkdir $outfolder
  pushd $outfolder
  cp ../$ref_card modified_card.dat
  sed -i "s|\<$nuis\>||g" modified_card.dat
  popd  

}


nuisances=""
for par in $pars; do
  # Important to keep the spaces in $par so it does not fetch nuisances whose name has $par in it
  nuis_par=$(grep $par $cardspath/$card | awk -F "${par}" '{print $1}') 
  nuisances="$nuisances $nuis_par"

done

## Now start building cases

it=0

# Case 0: consider everything 
nuis_before=everything
remove_nuis $card $cardspath/${it}_include-$nuis_before dummy # Make sure dummy is not written in the card lol

for nuis in $nuisances; do
    it_before=$it
    it=$(($it + 1))
    echo $nuis
    remove_nuis ${it_before}_include-${nuis_before}/modified_card.dat $cardspath/${it}_include-${nuis} $nuis # Make sure dummy is not written in the card lol
    nuis_before=$nuis
done




