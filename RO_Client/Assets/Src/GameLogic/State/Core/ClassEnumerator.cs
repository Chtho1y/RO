/**
 * @brief enumerator all types for this app
*/
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;

public class ClassEnumerator 
{
    protected List<Type> Results = new List<Type>();

    public List<Type> results { get { return Results; } }

    private Type AttributeType;
    private Type InterfaceType;

    public ClassEnumerator(
        Type InAttributeType,
        Type InInterfaceType,
        Assembly InAssembly,
        bool bIgnoreAbstract = true,
        bool bInheritAttribute = false,
        bool bShouldCrossAssembly = false
        )
    {
        AttributeType = InAttributeType;
        InterfaceType = InInterfaceType;

        try
        {
            if (bShouldCrossAssembly)
            {
                Assembly[] Assemblys = AppDomain.CurrentDomain.GetAssemblies();
                                
                if( Assemblys != null ) 
                {
                    for( int i= 0; i<Assemblys.Length; ++i)
                    {
                        var a = Assemblys[i];
                        CheckInAssembly(a, bIgnoreAbstract, bInheritAttribute);
                    }                    
                }
            }
            else
            {
                CheckInAssembly(InAssembly, bIgnoreAbstract, bInheritAttribute);
            }
        }
        catch (Exception e)
        {
            Debug.LogError("Error in enumerate classes :" + e.Message);
        }
    }

    protected void CheckInAssembly(
        Assembly InAssembly,
        bool bInIgnoreAbstract,
        bool bInInheritAttribute
        )
    {
        Type[] Types = InAssembly.GetTypes();

        if( Types != null)
        {
            for (int i = 0; i < Types.Length; ++i )
            {
                var t = Types[i];

                // test if it is implement from this interface
                if ( InterfaceType == null ||  InterfaceType.IsAssignableFrom(t))
                {
                    // check if it is abstract
                    if (!bInIgnoreAbstract || (bInIgnoreAbstract && !t.IsAbstract))
                    {
                        // check if it have this attribute
                        if (t.GetCustomAttributes(AttributeType, bInInheritAttribute).Length > 0)
                        {
                            Results.Add(t);

                            // Debug.Log("Found Type:" + t.FullName + " : " + a.GetName());
                        }
                    }
                }
            }   
        }
    }
}
