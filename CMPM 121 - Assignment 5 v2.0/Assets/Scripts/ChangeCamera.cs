using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeCamera : MonoBehaviour
{
    public GameObject FirstPerson;
    public GameObject ThirdPerson;
    public int cameraMode;

    // Update is called once per frame
    private void Start()
    {
        cameraMode = 1;
    }

    public void camChange()
    {
        if (cameraMode == 1) // 1 = first person
        {
            cameraMode = 0;
            ThirdPerson.SetActive(true);
            FirstPerson.SetActive(false);
        }
        else
        {
            cameraMode = 1;
            FirstPerson.SetActive(true);
            ThirdPerson.SetActive(false);
            }

    }
}
