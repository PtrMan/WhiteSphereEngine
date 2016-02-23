// from ProjectSci

module IDictionary;

interface IDictionary(KeyType, ValueType)
{
   // asserts if the key is allready used
   public void add(KeyType Key, ValueType Data);

   public bool contains(KeyType Key);

   // asserts if Key is not there
   public void remove(KeyType Key);

   // asserts if Key is not there
   public ValueType get(KeyType Key);

   // asserts if key is not there
   public void update(KeyType Key, ValueType Value);
}
