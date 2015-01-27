
a = [6,4,1,2,5,9,3,7,55,13];

quickSort = (arr,start,end)->
  if start < end
    base = arr[start]
    i = start
    j = end
    while i<j

        while i<j and arr[j]>base
          j--
        if i<j
          arr[i] = arr[j]

        while i<j and arr[i]<base
          i++
        if i<j
          arr[j] = arr[i]

    arr[i] = base
    console.log arr,start,end

    quickSort arr,start,i-1
    quickSort arr,i+1,end

quickSort a,0,a.length-1


























###
quickSort = (arr,start,end)->
  base = arr[start]
  i = start
  j = end
  console.log 'base=',base,' '+i,' '+j
  while i<j

    #找到一个arr[j]比base大
    while i<j and arr[j]>base
      j--
    if i<j
      arr[i] = arr[j]
    console.log i+'-'+j,a
    #找到一个arr[i]比base小
    while i<j and arr[i]<base
      i++
    if i<j
      arr[j] = arr[i]

    console.log i+'-'+j,a

  arr[i] = base

  return i

i  = quickSort a,0,a.length-1

i2 = quickSort a,0,i-1
i3 = quickSort a,i+1,a.length-1

i4 = quickSort a,0,i2-1
i5 = quickSort a,i2+1,i-i2
i6 = quickSort a,i+1,i3-1
i7 = quickSort a,i3+1,a.length-1

console.log a
###