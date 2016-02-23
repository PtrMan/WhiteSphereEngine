// from ProjectSci

module ListDictionary;

import IDictionary : IDictionary;

template ListDictionary(KeyType, ValueType)
{
   class ListDictionary : IDictionary!(KeyType, ValueType)
   {
      static private class KeyValue
      {
         public KeyType Key;
         public ValueType Value;

         this(KeyType Key, ValueType Value)
         {
            this.Key = Key;
            this.Value = Value;
         }
      }

      public void add(KeyType Key, ValueType Value)
      {
         // NOTE< we don't assert if a Key is allready used >

         this.KeyValues ~= new KeyValue(Key, Value);
      }

      public bool contains(KeyType Key)
      {
         foreach( IterationKeyValue; this.KeyValues )
         {
            if( IterationKeyValue.Key == Key )
            {
               return true;
            }
         }

         return false;
      }

      // asserts if Key is not there
      public void remove(KeyType Key)
      {
         // TODO
      }

      // asserts if Key is not there
      public ValueType get(KeyType Key)
      {
         foreach( IterationKeyValue; this.KeyValues )
         {
            if( IterationKeyValue.Key == Key )
            {
               return IterationKeyValue.Value;
            }
         }

         assert(false, "Can't find Key!");
      }

      // asserts if Key is not there
      public void update(KeyType Key, ValueType Value)
      {
         uint i;

         for( i = 0; i < this.KeyValues.length; i++ )
         {
            if( this.KeyValues[i].Key == Key )
            {
               this.KeyValues[i].Value = Value;
               return;
            }
         }

         assert(false, "Can't find Key!");
      }

      private KeyValue[] KeyValues;
   }
}